//
//  RectangleImageView.swift
//  PADO
//
//  Created by 황성진 on 2/5/24.
//

import Kingfisher
import SwiftUI

struct RectangleImageView: View {
    // MARK: - PROPERTY
    let imageUrl: String?
    
    // MARK: - BODY
    var body: some View {
        if let imageUrl = imageUrl {
            KFImage(URL(string: imageUrl))
                .fade(duration: 0.5)
                .placeholder {
                    Rectangle()
                        .fill(.main)
                        .frame(width: UIScreen.main.bounds.width * 1.0, height: 300)
                        .scaledToFill()
                }
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 1.0, height: 300)
                .scaledToFill()
        } else {
            Rectangle()
                .fill(.main)
                .frame(width: UIScreen.main.bounds.width * 1.0, height: 300)
                .scaledToFill()
                .foregroundStyle(Color(.systemGray4))
        }
    }
}
