//
//  StoryModel.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

var storyData: [Story] = [
    Story(name: "sirius", image: "pp"),
    Story(name: "dear.kang", image: "pp1"),
    Story(name: "Hsungjin", image: "Pic1"),
    Story(name: "Kminchae", image: "Pic2"),
    Story(name: "Dongho", image: "pp2"),
    Story(name: "k.cha_nam", image: "Pic4")
]
