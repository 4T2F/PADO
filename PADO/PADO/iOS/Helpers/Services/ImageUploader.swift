//
//  ImageUploader.swift
//  PADO
//
//  Created by 황성진 on 1/19/24.
//

import Firebase
import FirebaseStorage
import SwiftUI

// 파베에 이미지를 업로드하는 놈
struct ImageUploader {
    static func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Faile to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
}

