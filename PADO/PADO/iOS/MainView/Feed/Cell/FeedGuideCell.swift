//
//  FeedGuideCell.swift
//  PADO
//
//  Created by 최동호 on 2/15/24.
//

import Kingfisher
import SwiftUI

struct FeedGuideCell: View {
    @State var buttonActive: Bool = false
    
    let user: User
    var body: some View {
        GeometryReader(content: { proxy in
            let cardSize = proxy.size
            let minX = proxy.frame(in: .scrollView).minX - 30.0
            NavigationLink {
                OtherUserProfileView(buttonOnOff: $buttonActive,
                                        user: user)
            } label: {
                if let imageUrl = user.profileImageUrl {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(x: -minX)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .overlay {
                            overlayView(user)
                        }
                        .clipShape(.rect(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                }
            }
        })
    }
    
    @ViewBuilder
    func overlayView(_ user: User) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.2),
                .black.opacity(0.3),
                .black.opacity(0.4),
                .black.opacity(0.5),
            ], startPoint: .top, endPoint: .bottom)
            
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(user.username)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(user.nameID)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
                
                FollowButtonView(cellUser: user,
                                 buttonActive: $buttonActive,
                                 activeText: "팔로우",
                                 unActiveText: "팔로우 취소",
                                 widthValue: 85,
                                 heightValue: 28,
                                 buttonType: ButtonType.direct)
            })
            .padding(20)
        })
    }
}


