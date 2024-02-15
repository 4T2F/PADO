//
//  ToolModal.swift
//  PADO
//
//  Created by 김명현 on 2/15/24.
//

import SwiftUI

struct ToolModal: View {
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("그리기")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.grayButton)
                    .cornerRadius(10)
            }

            Button {
                
            } label: {
                Text("텍스트 추가")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.grayButton)
                    .cornerRadius(10)
            }
            
            
            Button {
                
                
            } label: {
                Text("사진 추가")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                    .background(.grayButton)
                    .cornerRadius(10)
            }
        }
        
    }
}
