//
//  Heart.swift
//  PADO
//
//  Created by 최동호 on 1/25/24.
//

import FirebaseFirestore

struct Comment: Identifiable, Hashable, Decodable {
    @DocumentID var id: String?

    var userID: String
    var content: String
    var time: Timestamp
    var heartIDs: [String] = []
    var replyComments: [String] = []
}

struct ReplyComment: Identifiable, Hashable, Decodable {
    @DocumentID var id: String?
    
    var userID: String
    var content: String
    var time: Timestamp
    var heartIDs: [String] = []
}
