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
import SwiftUI

class PadoRideViewModel: ObservableObject {
    @Published var selectedImage: String = ""
    @Published var selectedUIImage: UIImage?
    @Published var postsData: [String: [Post]] = [:]
    
    @Published var selectedPost: Post?
    
    @Published var isShowingEditView: Bool = false
    
    // Pencil킷 관련 변수들
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var textBoxes: [TextBox] = []
    @Published var addNewBox = false
    @Published var currentIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var decoUIImage: UIImage = UIImage()
    @Published var showingModal: Bool = false
    
    let getPostData = GetPostData()
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
        canvas = PKCanvasView()
        toolPicker = PKToolPicker()
        textBoxes.removeAll()
        currentIndex = 0
        addNewBox = false
    }
    
    @MainActor
    func cancelTextView() async {
        
        self.toolPicker.setVisible(true, forFirstResponder: self.canvas)
        self.canvas.becomeFirstResponder()
        
        withAnimation {
            addNewBox = false
        }
        
        if textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
        }
    }
    
    // 특정 ID들에 대한 포스트 데이터를 미리 로드
    func preloadPostsData(for ids: [String]) async {
        for id in ids {
            let posts = await getPostData.suffingPostData(id: id)
            DispatchQueue.main.async {
                self.postsData[id] = posts
            }
        }
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let makeUIView = ZStack {
            ForEach(textBoxes){[self] box in
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: 30))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
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
            
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            
            decoUIImage = UIImage(data: image) ?? UIImage()
        }
    }
    
    func sendPostAtFirebase() async {
        let filename = "\(userNameID)-\(String(describing: selectedPost?.id ?? ""))"
        
        let storageRef = Storage.storage().reference(withPath: "/pado_ride/\(filename)")
        
        guard let imageData = decoUIImage.jpegData(compressionQuality: 1.0) else { return }
        
        do {
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
}
