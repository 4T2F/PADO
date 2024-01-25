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
    @Published var cameraImage: Image = Image(systemName: "photo")
    
    @Published var postingImage: Image = Image(systemName: "photo")
    @Published var postingTitle: String = ""
    
    @Published var isLoading: Bool = false
    @State var progress: Double = 0
    
    @Published var searchResult: [User] = []
    @Published var post: [Post]?
    @Published var viewState: ViewState = ViewState.empty
    
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
    func postRequest() {
        // 게시 요청 관련 로직 추가
        
        UpdateUserData.shared
    }
}
