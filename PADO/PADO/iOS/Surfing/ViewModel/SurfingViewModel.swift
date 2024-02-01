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

class SurfingViewModel: ObservableObject, Searchable  {
    
    @Published var selectedImage: UIImage?
    @Published var pickerResult: [PHPickerResult] = []
    @Published var showPhotoPicker = false
    @Published var showingPermissionAlert = false
    @Published var selectedUIImage: Image = Image(systemName: "photo")
    
    @Published var showPostView: Bool = false
    @Published var isShownCamera: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var cameraDevice: UIImagePickerController.CameraDevice = .rear
    @Published var cameraUIImage: UIImage = UIImage()
    @Published var cameraImage: Image = Image(systemName: "photo")
    
    @Published var postingUIImage: UIImage?
    @Published var postingImage: Image = Image(systemName: "photo")
    @Published var postingTitle: String = ""
    
    @Published var showCropView: Bool = false
    @Published var cropResult: Bool = false
    
    // 페이스 모지 관련 변수
    @Published var faceMojiUIImage: UIImage = UIImage()
    @Published var faceMojiImage: Image = Image(systemName: "photo")
    
    @Published var isLoading: Bool = false
    @State var progress: Double = 0
    
    @Published var searchResult: [User] = []
    @Published var post: [Post]?
    @Published var viewState: ViewState = ViewState.empty
    
    @Published var moveTab: Int = 0
    
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
    func postRequest(imageURL: String) async {
        // 게시 요청 관련 로직 추가
        let initialPostData : [String: Any] = [
            "ownerUid": userNameID,
            "imageUrl": imageURL,
            "title": postingTitle,
            "heartsCount": 0,
            "commentCount": 0,
            "created_Time": Timestamp()
       ]
        await createPostData(titleName: formattedPostingTitle, data: initialPostData)
    }
    
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
        pickerResult = []
        showPhotoPicker = false
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
}
