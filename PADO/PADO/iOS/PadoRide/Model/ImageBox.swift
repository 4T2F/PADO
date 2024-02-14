//
//  ImageBox.swift
//  PADO
//
//  Created by 김명현 on 2/14/24.
//

import SwiftUI

struct ImageBox: Identifiable {

    var id = UUID().uuidString
    var image = Image(systemName: "bolt")
    var uiimage = UIImage()
  
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
 
    var isAdded: Bool = false
}

