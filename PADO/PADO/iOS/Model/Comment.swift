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

    let userID: String
    let content: String
    let time: Timestamp
}
