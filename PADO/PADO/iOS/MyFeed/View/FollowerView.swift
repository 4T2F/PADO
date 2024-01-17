//
//  FollowerView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowerView: View {
    // MARK: - PROPERTY
    @Environment (\.dismiss) var dismiss
    @State private var searchText: String = ""
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.mainBackground.ignoresSafeArea()
            VStack {
                ZStack {
                    Text("팔로워")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    SearchView(searchText: $searchText)
                        .padding()
                    
                    ScrollView(.vertical) {
                        HStack{
                            Text("내 서퍼")
                                .font(.system(size: 14, weight: .semibold))
                                .padding()
                            Spacer()
                        } //: HSTACK
                        
                        ForEach(1...2, id: \.self) { _ in
                            FollowerUserCellView(sufferset: .removesuffer)
                                .padding(.vertical)
                        }
                        
                        HStack{
                            Text("팔로워")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        } //: HSTACK
                        .padding(.horizontal)
                        
                        ForEach(1...10, id: \.self) { _ in
                            FollowerUserCellView(sufferset: .setsuffer)
                                .padding(.vertical)
                        }
                    } //: SCROLL
                } //: VSTACK
            } //: VSTACK
        } //: ZSTACK
    }
}

#Preview {
    FollowerView()
}
