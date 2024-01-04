//
//  Friends.swift
//  PADO
//
//  Created by 이민영 on 2024/01/05.
//

import Firebase
import FirebaseFirestoreSwift

struct Friend: Decodable, Identifiable{
    @DocumentID var id: String?
    var username: String?
    var name: String
    var profileImageUrl: String?
}
