//
//  TouchBackImageView.swift
//  PADO
//
//  Created by 황성진 on 2/16/24.
//

import Kingfisher
import SwiftUI

struct TouchBackImageView: View {
    
    let user: User
    
    var body: some View {
        ZStack {
            KFImage(URL(string: user.backProfileImageUrl ?? ""))
                .resizable()
                .placeholder({ _ in
                    Rectangle()
                        .foregroundStyle(.black)
                })
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: UIScreen.main.bounds.width * 1.0, height: 400)
        }
    }

}
