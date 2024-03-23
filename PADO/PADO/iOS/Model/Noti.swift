//
//  Noti.swift
//  PADO
//
//  Created by 황민채 on 2/3/24.
//

import FirebaseFirestore

struct Noti: Identifiable, Decodable {
    @DocumentID var id: String?
    
    var type: String
    var postID: String?
    var message: String?
    var sendUser: String
    var createdAt: Timestamp
    var read: Bool
}
