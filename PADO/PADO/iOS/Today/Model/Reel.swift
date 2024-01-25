//
//  Reel.swift
//  PADO
//
//  Created by 강치우 on 1/25/24.
//

import SwiftUI

struct Reel {
    var id = UUID()
    var imageName: String
    var author: String
    var content: String
}

let sampleReels = [
    Reel(imageName: "Pic0", author: "작성자1", content: "내용1"),
    Reel(imageName: "Pic1", author: "작성자2", content: "내용2"),
    Reel(imageName: "Pic2", author: "작성자2", content: "내용2"),
    Reel(imageName: "Pic3", author: "작성자2", content: "내용2"),
    Reel(imageName: "Pic4", author: "작성자2", content: "내용2")
]
