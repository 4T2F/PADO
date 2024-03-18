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
    case photoMoji
    case backImage
}

enum ImageQuality: Double {
    case lowforPhotoMoji = 0.25
    case middleforProfile = 0.5
    case highforPost = 1.0
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
    
    func updateImageUserData(uiImage: UIImage?, storageTypeInput: StorageTypeInput, documentid: String, imageQuality: ImageQuality, surfingID: String) async throws -> String {
        let returnString = try await updateProfileImage(uiImage: uiImage,
                                                        storageTypeInput: storageTypeInput,
                                                        documentid: documentid,
                                                        imageQuality: imageQuality,
                                                        surfingID: surfingID)
        return returnString
    }
    
    // ImageUploader를 통해 Storage에 이미지를 올리고 imageurl을 매개변수로 updateUserProfileImage에 넣어줌
    func updateProfileImage(uiImage: UIImage?, storageTypeInput: StorageTypeInput, documentid: String, imageQuality: ImageQuality, surfingID: String) async throws -> String {
        guard let image = uiImage else { throw ImageLoadError.imageCreationFailed }
        
        switch storageTypeInput {
        case .user, .photoMoji, .backImage:
            guard let imageUrl = try? await uploadImageToStorage(image: image,
                                                                 storageTypeInput: storageTypeInput,
                                                                 imageQuality: imageQuality)
            else {
                throw ImageLoadError.imageCreationFailed
            }
            let returnString = try await updateImageToStore(withImageUrl: imageUrl,
                                                            storageTypeInput: storageTypeInput,
                                                            documentid: documentid,
                                                            surfingID: "")
            return returnString
            
        case .post:
            guard let imageUrl = try? await uploadImageToStorage(image: image,
                                                                 storageTypeInput: storageTypeInput,
                                                                 imageQuality: imageQuality)
            else {
                throw ImageLoadError.imageCreationFailed
            }
            let returnString = try await updateImageToStore(withImageUrl: imageUrl,
                                                            storageTypeInput: storageTypeInput,
                                                            documentid: documentid,
                                                            surfingID: surfingID)
            return returnString
        }
        
        // 파이어베이스 스토리지에 이미지를 업로드하는 메서드
        func uploadImageToStorage(image: UIImage, storageTypeInput: StorageTypeInput, imageQuality: ImageQuality) async throws -> String? {
            guard !userNameID.isEmpty else { return nil }
            let filename = userNameID
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            
            let formattedDate = dateFormatter.string(from: Date())
            formattedPostingTitle = filename+formattedDate
                        
            // UIImage를 CIImage로 변환후 다시 UIImage로 바꿔주면서 이미지 포맷 정규화 시킴
            if let ciImage = CIImage(image: image) {
                let context = CIContext(options: nil)
                if let newCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
                    let normalizedImage = UIImage(cgImage: newCGImage)
                    guard let normalizedImageData = normalizedImage.jpegData(compressionQuality: imageQuality.rawValue) else { return nil }
                    switch storageTypeInput {
                    case .user:
                        let storageRef = Storage.storage().reference(withPath: "/profile_image/\(filename)")
                        do {
                            _ = try await storageRef.putDataAsync(normalizedImageData)
                            let url = try await storageRef.downloadURL()
                            return url.absoluteString
                        } catch {
                            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                            return nil
                        }
                        
                    case .post:
                        let storageRef = Storage.storage().reference(withPath: "/post/\(formattedPostingTitle)")
                        do {
                            _ = try await storageRef.putDataAsync(normalizedImageData)
                            let url = try await storageRef.downloadURL()
                            return url.absoluteString
                        } catch {
                            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                            return nil
                        }
                        
                    case .photoMoji:
                        let storageRef = Storage.storage().reference(withPath: "/facemoji/\(filename)-\(documentid)")
                        do {
                            _ = try await storageRef.putDataAsync(normalizedImageData)
                            let url = try await storageRef.downloadURL()
                            return url.absoluteString
                        } catch {
                            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                            return nil
                        }
                    case .backImage:
                        let storageRef = Storage.storage().reference(withPath: "/back_image/\(filename)")
                        do {
                            _ = try await storageRef.putDataAsync(normalizedImageData)
                            let url = try await storageRef.downloadURL()
                            return url.absoluteString
                        } catch {
                            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
            return nil
        }
        
        // 전달받은 imageUrl의 값을 파이어스토어 모델에 올리고 뷰모델에 넣어줌
        func updateImageToStore(withImageUrl imageUrl: String, storageTypeInput: StorageTypeInput, documentid: String, surfingID: String) async throws -> String {
            
            guard !userNameID.isEmpty else { return "" }
            
            switch storageTypeInput {
                
            case .user:
                try await Firestore.firestore().collection("users").document(userNameID).updateData([
                    "profileImageUrl": imageUrl
                ])
                return imageUrl
            case .post:
                try await Firestore.firestore().collection("users").document(userNameID).collection("sendpost").document(formattedPostingTitle).setData([
                    "surfingID": surfingID,
                    "userID": userNameID,
                    "created_Time": Timestamp()
                ])
                
                try await Firestore.firestore().collection("users").document(surfingID).collection("mypost").document(formattedPostingTitle).setData([
                    "surferID": userNameID,
                    "userID": surfingID,
                    "created_Time": Timestamp()
                ])
                
                return imageUrl
            case .photoMoji:
                try await Firestore.firestore().collection("post").document(documentid).collection("facemoji").document(userNameID).setData([
                    "faceMojiImageUrl": imageUrl
                ])
                return imageUrl
            case .backImage:
                try await Firestore.firestore().collection("users").document(userNameID).updateData([
                    "backProfileImageUrl": imageUrl
                ])
                return imageUrl
            }
        }
        
    }
}
