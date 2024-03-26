//
//  SurfingViewModel.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import Firebase
import FirebaseFirestoreSwift

import PhotosUI
import SwiftUI

class SurfingViewModel: ObservableObject  {
    // 포스트 관련 변수
    @Published var post: Post?
    
    @Published var selectedImage: UIImage?
    @Published var pickerResult: [PHPickerResult] = []
    @Published var selectedUIImage: Image = Image(systemName: "photo")
    @Published var postingUIImage: UIImage?
    @Published var postingImage: Image = Image(systemName: "photo")
    @Published var postingTitle: String = ""
    @Published var cropResult: Bool = false
    
    // 뷰 오픈
    @Published var showPostView: Bool = false
    @Published var isShowingPhotoModal = false
    @Published var isShowingPhoto: Bool = false
    @Published var isShowPopularModal: Bool = false
    @Published var isShowFollowingModal: Bool = false
    @Published var isShownCamera: Bool = false
    @Published var showCropView: Bool = false
    @Published var showingPermissionAlert = false
    @Published var showPhotoPicker = false
    
    // 카메라 이미지
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var cameraDevice: UIImagePickerController.CameraDevice = .rear
    @Published var cameraUIImage: UIImage = UIImage()
    @Published var cameraImage: Image = Image(systemName: "photo")
    
    // 포토 모지 관련 변수
    @Published var photoMojiUIImage: UIImage = UIImage()
    @Published var photoMojiImage: Image = Image(systemName: "photo")
    @Published var isShowingPhotoMojiModal: Bool = false
    
    // 온보팅 탭바 이동
    @Published var showingTab: Int = 0
    
    // 이미지 크롭 변수들
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    @Published var offset: CGSize = .zero
    @Published var lastStoredOffset: CGSize = .zero
    @Published var showinGrid: Bool = false
    @Published var imageChangeButton: Bool = false
    @Published var selectedColor = Color.main
    
    // 포스팅 페이지 관련 변수들
    @Published var postLoading = false
    @Published var showAlert = false
    @Published var postOwner: User? = nil

    @MainActor
    @Published var photoMojiItem: PhotosPickerItem? {
        didSet {
            Task {
                do {
                    let (loadedUIImage, loadedSwiftUIImage) = try await UpdateImageUrl.shared.loadImage(selectedItem: photoMojiItem)
                    self.photoMojiUIImage = loadedUIImage
                    self.photoMojiImage = loadedSwiftUIImage
                } catch {
                    print("선택 이미지 초기화: \(error)")
                }
            }
        }
    }
    
    @MainActor
    @Published var postImageItem: PhotosPickerItem? {
        didSet {
            Task {
                do {
                    let (loadedUIImage, loadedSwiftUIImage) = try await UpdateImageUrl.shared.loadImage(selectedItem: postImageItem)
                    self.selectedImage = loadedUIImage
                    self.selectedUIImage = loadedSwiftUIImage
                } catch {
                    print("선택 이미지 초기화: \(error)")
                }
            }
        }
    }
    
    var photoImageSize: CGRect {
        return ImageRatioResize.shared.resizedImageRect(for: selectedImage ?? UIImage(),
                                                                  targetSize: CGSize(
                                                                    width: UIScreen.main.bounds.width * 0.95,
                                                                    height: UIScreen.main.bounds.height * 0.8))
    }
    
    var cameraImageSize: CGRect {
        return ImageRatioResize.shared.resizedImageRect(for: cameraUIImage ,
                                                        targetSize: CGSize(
                                                            width: UIScreen.main.bounds.width * 0.95,
                                                            height: UIScreen.main.bounds.height * 0.8))
    }
    
    // MARK: - 권한 설정 및 확인
    // 카메라 권한 확인 함수 추가
    func checkCameraPermission(completion: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        completion()
                    }
                }
            }
        default:
            break
        }
    }
    
    // 갤러리 권한 확인 함수 추가
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            showPhotoPicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized {
                        self.showPhotoPicker = true
                    } else {
                        self.showingPermissionAlert = true
                    }
                }
            }
        case .restricted, .denied:
            showingPermissionAlert = true
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - 게시글 요청
    @MainActor
    func postRequest(imageURL: String, surfingID: String) async {
        // 게시 요청 관련 로직 추가
        let initialPostData : [String: Any] = [
            "ownerUid": surfingID,
            "surferUid": userNameID,
            "imageUrl": imageURL,
            "title": postingTitle,
            "heartIDs": [""],
            "commentCount": 0,
            "created_Time": Timestamp(),
            "padoExist": false
        ]
        await createPostData(titleName: formattedPostingTitle, 
                             data: initialPostData)
        post?.ownerUid = surfingID
        post?.surferUid = userNameID
        post?.imageUrl = imageURL
        post?.title = postingTitle
        post?.heartIDs = [""]
        post?.commentCount = 0
        post?.created_Time = Timestamp()
        post?.padoExist = false
    }
    
    @MainActor
    func createPostData(titleName: String, data: [String: Any]) async {
        do {
            try await Firestore.firestore().collection("post").document(titleName).setData(data)
            
        } catch {
            print("Error saving post data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 이미지 관련 초기화
    func resetImage() {
        selectedImage = nil
        showingPermissionAlert = false
        selectedUIImage = Image(systemName: "photo")
        
        showPostView = false
        isShownCamera = false
        cameraUIImage = UIImage()
        cameraImage = Image(systemName: "photo")
        
        postingUIImage = nil
        postingImage = Image(systemName: "photo")
        postingTitle = ""
        
        showCropView = false
        cropResult = false
    }
    
    func cameraBtnTapped() {
        isShowingPhotoModal = false
        isShownCamera.toggle()
        sourceType = .camera
        pickerResult = []
        selectedImage = nil
        selectedUIImage = Image(systemName: "photo")
    }
}
