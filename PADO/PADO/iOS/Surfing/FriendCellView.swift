//
//  FriendCellView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct FriendCellView: View {
    var body: some View {
        HStack {
            Image("pp2")
                .resizable()
                .frame(width: 65, height: 65)
                .cornerRadius(65/2)
            
            VStack(alignment: .leading) {
                Text("동호")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                
                Text("donghochoi")
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
                .padding(.leading, 6)
        }
        .padding(.horizontal)
    }
}

#Preview {
    FriendCellView()
}
