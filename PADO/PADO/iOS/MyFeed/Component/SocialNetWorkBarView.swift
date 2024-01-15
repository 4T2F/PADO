//
//  SocialNetWorkBarView.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import SwiftUI

struct SocialNetWorkBarView: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image("instagram-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            Rectangle()
                .frame(width: 1, height: 30)
                .foregroundStyle(Color(.systemGray2))
                .padding(.horizontal)
            
            Button {
                
            } label: {
                Image("tictok-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
            }
        }
        .padding()
        .background(
            Rectangle()
                .cornerRadius(20)
                .backgroundStyle(Color.white)
                .opacity(0.8)
        )
    }
}

#Preview {
    SocialNetWorkBarView()
}
