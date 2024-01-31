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
        case xmark = "xmark"
    }
    
    let searchRightSymbol: SearchRightSymbol
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            HStack {
                HStack(spacing: 0) {
                    Image("pp2")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("동호")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                        
                        Text("donghochoi")
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    Spacer()
                    
                    Image(systemName: searchRightSymbol.rawValue)
                        .foregroundStyle(Color(.systemGray))
                        .font(.system(size: 14))
                }
                
                
            } //: HSTACK
            .padding(.horizontal)
        } //: NAVI
    }
}


