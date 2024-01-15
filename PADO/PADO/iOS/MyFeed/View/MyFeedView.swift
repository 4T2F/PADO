//
//  MyFeedView.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import SwiftUI

struct MyFeedView: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color("mainBackgroundColor")
                .ignoresSafeArea(.all)
            
            VStack {
                MyFeedHeaderView()
                
                MyFeedContentView()
                
            } //: VSTACK
        } //: ZSTACK
    }
}

#Preview {
    MyFeedView()
}
