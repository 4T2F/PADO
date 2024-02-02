//
//  SufeSelectVIew.swift
//  PADO
//
//  Created by 황성진 on 2/2/24.
//

import Kingfisher
import SwiftUI

struct SuferSelectView: View {
    // MARK: - PROPERTY
    @ObservedObject var followVM: FollowViewModel
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                Text("서핑리스트")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 20)
                
                VStack {
                    ForEach(followVM.surferIDs, id: \.self) { surferId in
                        SuferSelectCell(followVM: followVM, cellUserId: surferId)
                    }
                }
                .padding()
            }
        }
    }
}
