//
//  PadoRideView.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import SwiftUI

struct PadoRideView: View {
    // MARK: - PROPERTY
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var padorideVM: PadoRideViewModel
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                
                Text("파도타기")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 40)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("다음")
                        .foregroundStyle(.white)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.trailing, 10)
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(followVM.surfingIDs, id: \.self) { surfingID in
                    SufferInfoCell(surfingID: surfingID)
                    
                    ScrollView(.horizontal) {
                        SufferPostCell(padorideVM: padorideVM, surfingID: surfingID)
                    }
                }
            }
        }
    }
}
