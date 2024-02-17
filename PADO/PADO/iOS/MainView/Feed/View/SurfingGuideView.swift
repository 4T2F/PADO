//
//  SurfingGuideView.swift
//  PADO
//
//  Created by 황성진 on 2/16/24.
//

import Kingfisher
import SwiftUI

struct SurfingGuideView: View {
    
    @State private var surfingUser: [User] = []
    @State private var surfingID: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 8) {
                Text("내가 팔로잉한 사람들")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                VStack {
                    Text("팔로잉한 사람들에게")
                    
                    Text("방명록에서 서퍼 지정을 요청해보세요.")
                }
                .foregroundColor(.gray)
                .font(.footnote)
                .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding([.leading, .top], 15)
            .padding(.bottom)
            
            GeometryReader(content: { geometry in
                let size = geometry.size
                let frameWidth = max(size.width - 80, 0)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        ForEach(surfingUser) { user in
                            SurfingGuideCell(user: user)
                                .frame(width: frameWidth, height: size.height - 0)
                                .scrollTransition(.interactive, axis: .horizontal) {
                                    view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .top)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            })
            .frame(height: 400)
            .padding(.top, 10)
            Spacer()
        }
        .onAppear {
            surfingUser.removeAll()
            
            // 배열의 인덱스를 셔플링합니다.
            let shuffledIndices = userFollowingIDs.indices.shuffled()
            
            // 셔플링된 인덱스에서 상위 5개를 선택합니다.
            // 단, 배열의 크기가 5보다 작은 경우, 배열의 크기만큼만 선택합니다.
            let numberOfSelections = min(userFollowingIDs.count, 5)
            let selectedIndices = shuffledIndices.prefix(numberOfSelections)
            
            // 선택된 인덱스에 해당하는 요소를 배열로 변환합니다.
            let selectedIDs = selectedIndices.map { userFollowingIDs[$0] }
            
            // 선택된 ID를 사용하여 작업을 수행합니다.
            Task {
                for id in selectedIDs {
                    let profileData = await UpdateUserData.shared.getOthersProfileDatas(id: id)
                    if let profileData = profileData {
                         surfingUser.append(profileData)
                    }
                }
            }
        }
    }
}
