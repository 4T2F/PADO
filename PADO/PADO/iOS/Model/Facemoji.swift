//
//  Facemoji.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import Firebase
import FirebaseFirestore
import Foundation

struct Facemoji : Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    
    let userID: String
    let faceMojiImageUrl: String
    let storagename: String
    let time: Timestamp
}
