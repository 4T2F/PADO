//
//  UpdateImageUrl.swift
//  PADO
//
//  Created by 황성진 on 1/26/24.
//

import Firebase
import FirebaseStorage
import PhotosUI
import SwiftUI

enum ImageLoadError: Error {
    case noItemSelected
    case dataLoadFailed
    case imageCreationFailed
}

class UpdateImageUrl {
    static let shared = UpdateImageUrl()
    
    private init() {} // 싱글톤 인스턴스를 위한 private initializer

    // MARK: - 스토리지 관련
    // PhotosUI를 통해 사용자 이미지에서 데이터를 받아옴
    func loadImage(selectedItem: PhotosPickerItem?) async throws -> (UIImage, Image) {
        guard let item = selectedItem else { throw ImageLoadError.noItemSelected }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { throw ImageLoadError.dataLoadFailed }
        guard let uiImage = UIImage(data: data) else { throw ImageLoadError.imageCreationFailed }
        
        let profileImageUrl = Image(uiImage: uiImage)
        
        return (uiImage, profileImageUrl)
    }
    
    func updateImageUserData(uiImage: UIImage?) async throws -> String {
        let returnString = try await updateProfileImage(uiImage: uiImage)
        return returnString
    }
    
    // ImageUploader를 통해 Storage에 이미지를 올리고 imageurl을 매개변수로 updateUserProfileImage에 넣어줌
    func updateProfileImage(uiImage: UIImage?) async throws -> String {
        guard let image = uiImage else { throw ImageLoadError.imageCreationFailed }
        guard let imageUrl = try? await uploadImage(image) else { throw ImageLoadError.imageCreationFailed }
        let returnString = try await updateUserProfileImage(withImageUrl: imageUrl)
        return returnString
    }
    
    // 파이어베이스 스토리지에 이미지를 업로드하는 메서드
    func uploadImage(_ image: UIImage) async throws -> String? {
        guard let currentUid = Auth.auth().currentUser?.uid else { return nil }
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let filename = currentUid
        let storageRef = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        do {
//            데이터 보낼 때 ProgressView에 사용될 Task
//            let uploadTask = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // 전달받은 imageUrl의 값을 파이어스토어 모델에 올리고 뷰모델에 넣어줌
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws -> String {
        guard let currentUid = Auth.auth().currentUser?.uid else { throw ImageLoadError.dataLoadFailed }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageUrl": imageUrl
        ])
        return imageUrl
        // currentUser?.profileImageUrl = imageUrl
    }
}