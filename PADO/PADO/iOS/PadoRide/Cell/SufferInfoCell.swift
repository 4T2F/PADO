//
//  SufferInfoCell.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import Kingfisher
import SwiftUI

struct SufferInfoCell: View {
    // MARK: - PROPERTY
    let surfingID: String
    
    @State var surfingUser: User?
    
    // MARK: - BODY
    var body: some View {
        HStack {
            if let user = surfingUser {
                CircularImageView(size: .small, user: user)
            }
            
            Text("\(surfingUser?.nameID ?? "")")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 5)
            
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                let returnUser = await UpdateUserData.shared.getOthersProfileDatas(id: surfingID)
                self.surfingUser = returnUser
            }
        }
    }
}

