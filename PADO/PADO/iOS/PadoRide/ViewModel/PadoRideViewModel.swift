//
//  PadoRideViewModel.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
import PencilKit
import PhotosUI
import SwiftUI

class PadoRideViewModel: ObservableObject {
    @Published var surfingUser: User?
    @Published var selectedImage: String = ""
    @Published var selectedUIImage: UIImage?
    @Published var postsData: [String: [Post]] = [:]
    @Published var postLoading = false
    
    @Published var selectedPost: Post?
    @Published var showTab: Int = 0
    
    @Published var isShowingEditView: Bool = false
    @Published var isShowingDrawingView: Bool = false
    @Published var showingModal: Bool = false
    @Published var selectedPickerImage: Image = Image("")
    @Published var selectedPickerUIImage: UIImage = UIImage()
    
    @Published var pickerImageItem: PhotosPickerItem?
    @Published var pickerImageSize: CGRect = .zero
    
    // Pencil킷 관련 변수들
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var textBoxes: [TextBox] = []
    @Published var imageBoxes: [ImageBox] = []
    @Published var addNewBox = false
    @Published var modifyBox = false
    @Published var currentTextIndex: Int = 0
    @Published var currentImageIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var decoUIImage: UIImage = UIImage()
    
    
    let getPostData = GetPostData()
    let cropWhiteBackground = CropWhiteBackground()
    let db = Firestore.firestore()
    
    // 선택된 이미지 URL을 기반으로 UIImage를 다운로드하고 저장하는 함수
    func downloadSelectedImage() {
        guard let url = URL(string: selectedImage) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                self.selectedUIImage = imageResult.image
                
            case .failure(let error):
                print(error)
                self.selectedUIImage = nil
            }
        }
    }
    
    func cancelImageEditing() {
        selectedUIImage = nil
        selectedImage = ""
        selectedPickerUIImage = UIImage()
        selectedPickerImage = Image("")
        decoUIImage = UIImage()
        canvas = PKCanvasView()
        toolPicker = PKToolPicker()
        textBoxes.removeAll()
        imageBoxes.removeAll()
        currentTextIndex = 0
        currentImageIndex = 0
        
    }
    
    func calculateTextSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let size = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = text.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return rect.size
    }
    
    // PhotosPickerItem에서 이미지 로드 및 처리
    func loadImageFromPickerItem(_ pickerItem: PhotosPickerItem?) async {
        guard let pickerItem = pickerItem else { return }
        
        do {
            // 선택한 항목에서 이미지 데이터 로드
            guard let imageData = try await pickerItem.loadTransferable(type: Data.self) else { return }
            
            if let uiImage = UIImage(data: imageData) {
                // 메인 스레드에서 UI 업데이트
                await MainActor.run {
                    // 이미지 데이터를 사용하여 ImageBox 생성 및 업데이트
                    pickerImageSize = ImageRatioResize.shared.resizedImageRect(for: uiImage, targetSize: CGSize(width: 300, height: 500))
                    let newImageBox = ImageBox(image: Image(uiImage: uiImage))
                    self.imageBoxes.append(newImageBox)
                    self.currentImageIndex = self.imageBoxes.count - 1
                    imageBoxes[currentImageIndex].size = pickerImageSize
                    imageBoxes[currentImageIndex].isAdded = true
                    pickerImageItem = nil
                }
            }
        } catch {
            // 오류 처리
            print("이미지 로딩 실패: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func cancelTextView() async {
        
        self.toolPicker.setVisible(true, forFirstResponder: self.canvas)
        self.canvas.becomeFirstResponder()
        
        withAnimation {
            addNewBox = false
            modifyBox = false
        }
        
        textBoxes[currentTextIndex].text = ""
        
    }
    
    @MainActor
    func deleteImage() async {
        self.toolPicker.setVisible(true, forFirstResponder: self.canvas)
        self.canvas.becomeFirstResponder()
        
        if imageBoxes[currentImageIndex].isAdded {
            imageBoxes.remove(at: currentImageIndex)
        }
    }
    
    // 특정 ID들에 대한 포스트 데이터를 미리 로드
    func loadPostsData(for id: String) async {
        let posts = await getPostData.suffingPostData(id: id)
        DispatchQueue.main.async {
            self.postsData[id] = posts
        }
    }
    
    @MainActor
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let makeUIView = ZStack {
            ForEach(textBoxes){[self] box in
                Text(textBoxes[currentTextIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: 70))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
                    .rotationEffect(box.rotation)
                    .scaleEffect(box.scale)
            }
            
            ForEach(imageBoxes){ box in
                box.image
                    .resizable()
                    .frame(width: box.size.width, height: box.size.height)
                    .offset(box.offset)
                    .rotationEffect(box.rotation)
                    .scaleEffect(box.scale)
            }
        }
        
        let controller = UIHostingController(rootView: makeUIView).view!
        controller.frame = rect
        
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData(){
            
            selectedUIImage = UIImage(data: image) ?? UIImage()
            
            Task {
                let testdecoUIImage = try await cropWhiteBackground.processImage(inputImage: selectedUIImage ?? UIImage())
                
                let ratioTest = await ImageRatioResize.shared.resizeImage(testdecoUIImage, toSize: CGSize(width: 900, height: 1500))
                
                decoUIImage = ratioTest
            }
            
        }
    }
    
    func sendPostAtFirebase() async {
        let filename = "\(userNameID)-\(String(describing: selectedPost?.id ?? ""))"
        
        let storageRef = Storage.storage().reference(withPath: "/pado_ride/\(filename)")
        
        guard let imageData = decoUIImage.jpegData(compressionQuality: 1.0) else { return }
        
        do {
            try await db.collection("post").document(String(describing: selectedPost?.id ?? "")).updateData(["padoExist": true])
            if savePhoto {
                UIImageWriteToSavedPhotosAlbum(decoUIImage, nil, nil, nil)
            }
            
            _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            
            try await db.collection("post")
                .document(String(describing: selectedPost?.id ?? ""))
                .collection("padoride")
                .document(userNameID)
                .setData(
                    ["imageUrl" : url.absoluteString,
                     "storageFileName" : "\(userNameID)-\(String(describing: selectedPost?.id ?? ""))",
                     "time" : Timestamp()]
                )
            
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
        }
    }
    
    func getTextIndex(textBox: TextBox) -> Int {
        
        let index = textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        
        return index
    }
    
    func getImageIndex(imageBox: ImageBox) -> Int {
        
        let index = imageBoxes.firstIndex { (box) -> Bool in
            return imageBox.id == box.id
        } ?? 0
        
        return index
    }
    
    func handleTextBoxDragGesture(value: DragGesture.Value, box: TextBox) {
        // 드래그 시작 시점의 offset 임시 저장
        let startOffset = box.lastOffset
        
        // 현재 드래그 변위
        let currentTranslation = value.translation
        
        // 회전 각도 고려하여 드래그 변위 조정
        let rotatedTranslation = CGPoint(
            x: currentTranslation.width * cos(-box.rotation.radians) - currentTranslation.height * sin(-box.rotation.radians),
            y: currentTranslation.width * sin(-box.rotation.radians) + currentTranslation.height * cos(-box.rotation.radians)
        )
        
        // 확대/축소를 고려한 최종 변위 적용
        let adjustedTranslation = CGSize(
            width: startOffset.width + (rotatedTranslation.x / box.scale),
            height: startOffset.height + (rotatedTranslation.y / box.scale)
        )
        
        // 변위 적용
        textBoxes[getTextIndex(textBox: box)].offset = adjustedTranslation
    }
    
    func handleImageBoxDragGesture(value: DragGesture.Value, box: ImageBox) {
        let startOffset = box.lastOffset
        
        // 현재 드래그 변위
        let currentTranslation = value.translation
        
        // 회전 각도 고려하여 드래그 변위 조정
        let rotatedTranslation = CGPoint(
            x: currentTranslation.width * cos(-box.rotation.radians) - currentTranslation.height * sin(-box.rotation.radians),
            y: currentTranslation.width * sin(-box.rotation.radians) + currentTranslation.height * cos(-box.rotation.radians)
        )
        
        // 확대/축소를 고려한 최종 변위 적용
        let adjustedTranslation = CGSize(
            width: startOffset.width + (rotatedTranslation.x / box.scale),
            height: startOffset.height + (rotatedTranslation.y / box.scale)
        )
        
        // 변위 적용
        imageBoxes[getImageIndex(imageBox: box)].offset = adjustedTranslation
    }
}
