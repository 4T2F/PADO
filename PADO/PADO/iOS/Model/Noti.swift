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
    
//    let sendUserID: String
//    let sendUserFcmToken: String
    let receiveUserId: String
    let receiveUserFcmToken: String
    let createAt: Timestamp
}
