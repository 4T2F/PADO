//
//  UserCellView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct UserCellView: View {
    // MARK: - PROPERTY
    @State private var buttonActive: Bool = false
    
    // MARK: - BODY
    var body: some View {
        HStack {
            CircularImageView(size: .small)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("user ID")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("user nickname")
                    .font(.system(size: 14, weight: .semibold))
                
            } //: VSTACK
            
            Spacer()
            
            BlueButtonView(buttonActive: $buttonActive, activeText: "팔로우", unActiveText: "팔로잉", widthValue: 80, heightValue: 30)
                .padding(.horizontal)
            
        } //: HSTACK
    }
}

#Preview {
    UserCellView()
}
