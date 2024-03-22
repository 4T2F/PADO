//
//  Post.swift
//  PADO
//
//  Created by 황민채 on 1/22/24.
//

import FirebaseFirestore

struct Post: Identifiable, Hashable, Decodable {
    @DocumentID var id: String?
    
    var ownerUid: String
    var surferUid: String
    var imageUrl: String
    var title: String
    var heartIDs: [String] = []
    var commentCount: Int
    var comments: [Comment]?
    var created_Time: Timestamp
    var modified_Time: Timestamp?
    var padoExist: Bool?
}
