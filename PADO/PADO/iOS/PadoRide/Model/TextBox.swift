//
//  TextBox.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import SwiftUI

struct TextBox: Identifiable {

    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
  
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    
    var width: CGFloat = 0
    var height: CGFloat = 0
 
    var isAdded: Bool = false
}
