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

enum StorageTypeInput: String {
    case user
    case post
    case facemoji
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
    
    func updateImageUserData(uiImage: UIImage?, storageTypeInput: StorageTypeInput) async throws -> String {
        let returnString = try await updateProfileImage(uiImage: uiImage, storageTypeInput: storageTypeInput)
        return returnString
    }
    
    // ImageUploader를 통해 Storage에 이미지를 올리고 imageurl을 매개변수로 updateUserProfileImage에 넣어줌
    func updateProfileImage(uiImage: UIImage?, storageTypeInput: StorageTypeInput) async throws -> String {
        guard let image = uiImage else { throw ImageLoadError.imageCreationFailed }
        
        switch storageTypeInput {
            
        case .user, .facemoji:
            guard let imageUrl = try? await uploadImageToStorage(image: image, storageTypeInput: storageTypeInput) else { throw ImageLoadError.imageCreationFailed }
            let returnString = try await updateImageToStore(withImageUrl: imageUrl, storageTypeInput: storageTypeInput)
            return returnString
            
        case .post:
            guard let imageUrl = try? await uploadImageToStorage(image: image, storageTypeInput: storageTypeInput) else { throw ImageLoadError.imageCreationFailed }
            return imageUrl
        }
    }
    
    // 파이어베이스 스토리지에 이미지를 업로드하는 메서드
    func uploadImageToStorage(image: UIImage, storageTypeInput: StorageTypeInput) async throws -> String? {
        guard let currentUid = Auth.auth().currentUser?.uid else { return nil }
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let filename = currentUid
        
        switch storageTypeInput {
            
        case .user:
            let storageRef = Storage.storage().reference(withPath: "/profile_image/\(filename)")
            do {
                _ = try await storageRef.putDataAsync(imageData)
                let url = try await storageRef.downloadURL()
                return url.absoluteString
            } catch {
                print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                return nil
            }
            
        case .post:
            let storageRef = Storage.storage().reference(withPath: "/post/\(filename)")
            do {
                _ = try await storageRef.putDataAsync(imageData)
                let url = try await storageRef.downloadURL()
                return url.absoluteString
            } catch {
                print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                return nil
            }
            
        case .facemoji:
            let storageRef = Storage.storage().reference(withPath: "/facemoji/\(filename)")
            do {
                _ = try await storageRef.putDataAsync(imageData)
                let url = try await storageRef.downloadURL()
                return url.absoluteString
            } catch {
                print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    // 전달받은 imageUrl의 값을 파이어스토어 모델에 올리고 뷰모델에 넣어줌
    func updateImageToStore(withImageUrl imageUrl: String, storageTypeInput: StorageTypeInput) async throws -> String {
        guard let currentUid = Auth.auth().currentUser?.uid else { throw ImageLoadError.dataLoadFailed }
        
        switch storageTypeInput {
            
        case .user:
            try await Firestore.firestore().collection("users").document(currentUid).updateData([
                "profileImageUrl": imageUrl
            ])
            return imageUrl
        case .post:
            return imageUrl
        case .facemoji:
            try await Firestore.firestore().collection("facemoji").document(currentUid).updateData([
                "faceMojiImageUrl": imageUrl
            ])
            return imageUrl
        }
    }
}
