//
//  Message.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//

import Firebase
import FirebaseFirestoreSwift

import Foundation

struct PostitMessage: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    
    let messageUserID: String
    let imageUrl: String
    let content: String
    let messageTime: Timestamp
}
