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
    let user: User
    
    // MARK: - BODY
    var body: some View {
        if let imageUrl = user.backProfileImageUrl {
            KFImage(URL(string: imageUrl))
                .fade(duration: 0.5)
                .placeholder {
                    Rectangle()
                        .fill(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                        .scaledToFit()
                }
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                .scaledToFit()
        } else {
            Rectangle()
                .fill(.black)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                .scaledToFit()
                .foregroundStyle(Color(.systemGray4))
        }
    }
}
