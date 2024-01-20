//
//  MyFeedView.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import SwiftUI

struct MyFeedView: View {
    // MARK: - PROPERTY
    @StateObject var viewModel = AuthenticationViewModel()
    private var currentUser: User? {
        return viewModel.currentUser
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                MyFeedHeaderView(user: currentUser)
                
                MyFeedContentView()
            } //: VSTACK
        } //: ZSTACK
    }
}

//#Preview {
//    MyFeedView()
//}
