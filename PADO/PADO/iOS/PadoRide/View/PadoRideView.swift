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
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            ForEach(followVM.surfingIDs, id: \.self) { surfingID in
                SufferInfoCell(surfingID: surfingID)
                
                ScrollView(.horizontal) {
                    SufferPostCell(surfingID: surfingID)
                }
            }
        }
    }
}
