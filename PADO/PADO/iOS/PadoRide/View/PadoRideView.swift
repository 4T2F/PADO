//
//  PadoRideView1.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct PadoRideView: View {
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var followVM: FollowViewModel
    
    @State private var isShowingOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            if userFollowingIDs.isEmpty {
                                Text("팔로우한 사람이 없어요")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                            } else if !followVM.surfingIDs.isEmpty {
                                Text("파도타기가 가능한 친구")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                            }
                            Spacer()
                            
                            Button {
                                isShowingOnboarding.toggle()
                            } label: {
                                Text("파도타기란?")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color(.systemGray))
                            }
                            .sheet(isPresented: $isShowingOnboarding, content: {
                                PadoRideOnboardingView()
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.fraction(0.99)])
                            })
                        }
                        
                        // 파도타기 할 수 있는 유저가 없으면 "파도타기를 할 수 있는 친구가 없어요" 텍스트 넣기
                        if userFollowingIDs.isEmpty {
                            Text("다른 유저를 팔로우하고\n방명록에 서퍼등록을 요청해보세요")
                                .lineSpacing(4)
                                .font(.system(size: 16, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .padding(.top, 100)
                            
                        } else if followVM.surfingIDs.isEmpty {
                            SurfingGuideView()
                        } else {
                            ForEach(followVM.surfingIDs, id: \.self) { surfingID in
                                SelectPadoRideUserCell(id: surfingID)
                            }
                        }
                    }
                    .padding()
                    
                    if !followVM.surfingIDs.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("회원님을 위한 추천")
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .foregroundStyle(Color(.systemGray))
                                .padding(.leading)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(feedVM.popularUsers, id: \.self) { user in
                                        FollowerSuggestionCell(user: user)
                                            .padding(.trailing, 4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .scrollIndicators(.hidden)
                        }
                        .padding(.top)
                    }
                }
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationTitle("파도타기")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}
