//
//  Heart.swift
//  PADO
//
//  Created by 최동호 on 2/1/24.
//

import Firebase
import FirebaseFirestore
import Foundation

struct Heart: Identifiable, Codable {
    @DocumentID var id: String?

    let userID: String
}
