//
//  Post.swift
//  PADO
//
//  Created by 황민채 on 1/22/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

var formattedPostingTitle = ""

struct Post: Identifiable, Codable {
 
    @DocumentID var id: String?
    var ownerUid: String
    var sufferUid: String?
    var imageUrl: String
    var title: String
    var hearts: Int
    var comments: [Comment]?
    var created_Time: Timestamp
    var modified_Time: Timestamp?
}
