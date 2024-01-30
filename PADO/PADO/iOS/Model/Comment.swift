//
//  Heart.swift
//  PADO
//
//  Created by 최동호 on 1/25/24.
//

import Firebase
import FirebaseFirestore
import Foundation

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?

    let userID: String
    let content: String
    let time: Timestamp
}
