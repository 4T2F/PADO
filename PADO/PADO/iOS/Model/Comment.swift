//
//  Heart.swift
//  PADO
//
//  Created by 최동호 on 1/25/24.
//

import Foundation

struct Comment: Identifiable, Codable {
    var id = UUID()
    let nameID: String
    let comment: String
    let time: String
}
