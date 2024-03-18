//
//  SufeSelectVIew.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import Kingfisher

import SwiftUI

struct SurfingSelectView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var followVM: FollowViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(followVM.surfingIDs, id: \.self) { surfingId in
                        SurfingSelectCell(followVM: followVM,
                                          cellUserId: surfingId)
                    }
                }
                .padding()
            }
            .background(.modal, 
                        ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("서핑 리스트")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            
                            Text("닫기")
                                .font(.system(.body))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .toolbarBackground(Color(.modal),
                               for: .navigationBar)
        }
    }
}
