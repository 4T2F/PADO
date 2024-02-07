//
//  Noti.swift
//  PADO
//
//  Created by 황민채 on 2/3/24.
//
import Firebase
import FirebaseFirestore
import Foundation

struct Noti: Identifiable, Codable {
    @DocumentID var id: String?
    
    var type: String
    var message: String?
    var sendUser: String
    var createdAt: Timestamp
    var read: Bool
}
