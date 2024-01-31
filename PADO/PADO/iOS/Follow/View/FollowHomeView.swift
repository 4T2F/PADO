//
//  Home.swift
//  PADO
//
//  Created by 황민채 on 1/31/24.
//

import SwiftUI

struct FollowHomeView: View {
    @State var currentSelection: Int = 0
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var followVM: FollowViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Text("\(userNameID)")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("dismissArrow")
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    PagerTabView(tint: .black, selection: $currentSelection) {
                        
                        Text("\(followVM.followerIDs.count + followVM.surferIDs.count) 팔로워")
                            .foregroundStyle(currentSelection == 0 ? Color.white : Color.gray) // 조건부 색상 적용
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .pageLabel()
                        
                        Text("\(followVM.followingIDs.count) 팔로잉")
                            .foregroundStyle(currentSelection == 1 ? Color.white : Color.gray) // 조건부 색상 적용
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .pageLabel()
                        
                    } content: {
                        
                        ZStack {
                            FollowerView(followVM: FollowViewModel())
                            
                        }
                        .pageView(ignoresSafeArea: true, edges: .bottom)
                        
                        ZStack{
                            FollowingView(followVM: FollowViewModel())
                        }
                        .pageView(ignoresSafeArea: true, edges: .bottom)
                        
                    }
                    .padding(.top)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }
}
    



