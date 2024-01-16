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
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.mainBackground.ignoresSafeArea()
            VStack {
                ZStack {
                    Text("팔로잉")
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
            } //: VSTACK
            // code
        } //: ZSTACK
    }
}

#Preview {
    FollowerView()
}
