//
//  StoryCell.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import Kingfisher
import SwiftUI

struct StoryCell: View {
    
    var story: Story
    @State var profileId: String = ""
    @State var imageProfileUrl: String = ""
    @ObservedObject var vm: FeedViewModel

    var onTap: () -> Void  // 탭 동작을 위한 클로저
    
    var body: some View {
        VStack {
            KFImage.url(URL(string: imageProfileUrl))
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(70)
            Text(profileId)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        .onAppear {
            Task {
                let userData = await vm.setupProfileImageURL(id: story.name)
                profileId = userData[0]
                imageProfileUrl = userData[1]
            }
        }
        .onTapGesture {
            onTap()  // 텍스트를 탭했을 때 클로저 호출
        }
    }
}
