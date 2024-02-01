//
//  StoryModel.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct Story: Identifiable, Hashable, Codable {
    var id = UUID()
    
    let postID: String
    let name: String
    let image: String
    let title: String
    let postTime: Timestamp
}