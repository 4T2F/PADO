//
//  Message.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//

import FirebaseFirestore

struct PostitMessage: Identifiable, Decodable {
    @DocumentID var id: String?
    
    let messageUserID: String
    let imageUrl: String
    let content: String
    let messageTime: Timestamp
}
