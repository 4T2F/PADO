//
//  Heart.swift
//  PADO
//
//  Created by 최동호 on 1/25/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Comment: Identifiable, Hashable, Codable {
    @DocumentID var id: String?

    var userID: String
    var content: String
    var time: Timestamp
    var heartIDs: [String] = []
    var replyComments: [String] = []
}

struct ReplyComment: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var userID: String
    var content: String
    var time: Timestamp
    var heartIDs: [String] = []
}
