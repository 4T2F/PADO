//
//  PadoRideView1.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct PadoRideView: View {
    @ObservedObject var feedVM: FeedViewModel
    
    @State var surfingIDs: [String]
    @State private var isShowingOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            if userFollowingIDs.isEmpty {
                                Text("팔로우한 사람이 없어요")
                                    .font(.system(.body))
                                    .fontWeight(.medium)
                            } else if !surfingIDs.isEmpty {
                                Text("파도타기가 가능한 친구")
                                    .font(.system(.body))
                                    .fontWeight(.medium)
                            }
                            Spacer()
                            
                            Button {
                                isShowingOnboarding.toggle()
                            } label: {
                                Text("파도타기란?")
                                    .font(.system(.footnote))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color(.systemGray))
                            }
                            .sheet(isPresented: $isShowingOnboarding, content: {
                                PadoRideOnboardingView()
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.fraction(0.99)])
                            })
                        }
                        
                        if userFollowingIDs.isEmpty {
                            Text("다른 유저를 팔로우하고\n방명록에 서퍼등록을 요청해보세요")
                                .lineSpacing(4)
                                .font(.system(.body, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .padding(.top, 100)
                            
                        } else if surfingIDs.isEmpty {
                            SurfingGuideView()
                        } else {
                            ForEach(surfingIDs, id: \.self) { surfingID in
                                SelectPadoRideUserCell(id: surfingID)
                            }
                        }
                    }
                    .padding()
                    
                    if !surfingIDs.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("회원님을 위한 추천")
                                .font(.system(.footnote))
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
