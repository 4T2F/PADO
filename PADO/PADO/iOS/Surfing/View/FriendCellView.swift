//
//  FriendCellView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//
// ITEM

import SwiftUI

struct FriendCellView: View {
    // MARK: - PROPERTY
    enum SearchRightSymbol: String {
        case chevron = "chevron.right"
        case xmark = "xmark.circle"
    }
    
    let searchRightSymbol: SearchRightSymbol
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
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
                
                NavigationLink(destination: SurfingMakeView()) {
                    Image(systemName: searchRightSymbol.rawValue)
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                        .padding(.leading, 6)
                }
            } //: HSTACK
            .padding(.horizontal)
        } //: NAVI
    }
}

//#Preview {
//    FriendCellView(searchRightSymbol: .chevron)
//}
