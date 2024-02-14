//
//  TripCard.swift
//  uheung
//
//  Created by 강치우 on 10/31/23.
//

import SwiftUI

// Trip Card Model
struct SuggestionModel: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

// Image Cards
var tripCards: [SuggestionModel] = [
    .init(title: "하나비", subTitle: "hanabi", image: "Pic0"),
    .init(title: "동호", subTitle: "m2pro256", image: "Pic3"),
    .init(title: "민차이", subTitle: "minchai", image: "Pic2"),
    .init(title: "힁성진", subTitle: "hingsung", image: "Pic1"),
    .init(title: "김차남", subTitle: "chanam", image: "Pic4")
]
