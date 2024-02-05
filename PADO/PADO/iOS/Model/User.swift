//
//  User.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

var userNameID: String {
    get {
        UserDefaults.standard.string(forKey: "userNameID") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "userNameID")
    }
}

var userToken: String {
    get {
        UserDefaults.standard.string(forKey: "userToken") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "userToken")
    }
}

var userAlertAccept: String {
    get {
        UserDefaults.standard.string(forKey: "userAlertAccept") ?? "no"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "userAlertAccept")
    }
}

struct User: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var username: String // 유저 닉네임
    var lowercasedName: String
    var nameID: String
    var profileImageUrl: String?
    var backProfileImageUrl: String?
    var date: String // 날짜가 문자열로 저장된 경우
    var bio: String?
    var location: String?
    var phoneNumber: String
    var fcmToken: String
    var alertAccept: String // 필드 이름 수정
    var instaAddress: String
    var tiktokAddress: String
}
