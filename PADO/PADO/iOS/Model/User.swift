//
//  User.swift
//  PADO
//
//  Created by 강치우 on 1/3/24.
//

import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var username: String?
    var nameID: String
    var profileImageUrl: String?
    var date: String
    var bio: String?
    var location: String?
    var phoneNumber: String

}

