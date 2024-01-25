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

    // 사진 선택 완료 처리 (Camera와 PhotoPicker에서 사용)
    func handleImageSelected(_ uiImage: UIImage) {
           self.selectedImage = uiImage
           self.selectedUIImage = Image(uiImage: uiImage)
       }
    
    func postRequest() {
          // 게시 요청 관련 로직 추가
      }
}
