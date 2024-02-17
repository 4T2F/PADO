//
//  TouchProfileView.swift
//  PADO
//
//  Created by 황성진 on 2/16/24.
//

import Kingfisher
import SwiftUI

struct TouchProfileView: View {
    let user: User
    
    var body: some View {
        ZStack {
            KFImage(URL(string: user.profileImageUrl ?? ""))
                .resizable()
                .placeholder({ _ in
                    Image("defaultProfile")
                })
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 300, height: 300)
        }
    }
}
