//
//  BlockedUser.swift
//  PADO
//
//  Created by 강치우 on 2/16/24.
//

import Firebase
import FirebaseFirestore
import Foundation

struct BlockedUser: Identifiable, Codable {
    @DocumentID var id: String?
    
    var blockedUserID: String
    var blockTime: Timestamp
}
