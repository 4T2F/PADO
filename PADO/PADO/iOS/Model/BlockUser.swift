//
//  BlockedUser.swift
//  PADO
//
//  Created by 강치우 on 2/16/24.
//

import FirebaseFirestore

struct BlockUser: Identifiable, Decodable {
    @DocumentID var id: String?
    
    var blockUserID: String
    var blockUserProfileImage: String
    var blockTime: Timestamp
}
