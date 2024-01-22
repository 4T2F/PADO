//
//  Post.swift
//  PADO
//
//  Created by 황민채 on 1/22/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Post {
    var ownerUid: String
    var sufferUid: String
    var imageUrl: String
    var postTitle: String
    var timestamp: Timestamp
}
