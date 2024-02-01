//
//  CommentCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import Kingfisher
import SwiftUI

struct CommentCell: View {
    let comment: Comment
    @State private var user: User? = nil
    @State private var isUserLoaded = false
    
    @ObservedObject var feedVM: FeedViewModel
    var body: some View {
        HStack(alignment: .top) {
            
            Button {
                Task {
                    // 비동기 함수를 사용하여 사용자 데이터를 가져옵니다.
                    let fetchedUser = await feedVM.fetchUserData(id: comment.userID)
                    self.user = fetchedUser
                    self.isUserLoaded = true // 사용자가 로드되었음을 나타냅니다.
                }
            } label: {
                if let imageUrl = comment.profileImageUrl {
                    KFImage(URL(string: imageUrl))
                        .fade(duration: 0.5)
                        .placeholder{
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 34, height: 34)
                        .clipShape(Circle())
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .padding(.trailing, 6)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    Button {
                        Task {
                            // 비동기 함수를 사용하여 사용자 데이터를 가져옵니다.
                            let fetchedUser = await feedVM.fetchUserData(id: comment.userID)
                            self.user = fetchedUser
                            self.isUserLoaded = true // 사용자가 로드되었음을 나타냅니다.
                        }
                    } label: {
                        Text(comment.userID)
                            .fontWeight(.semibold)
                            .font(.caption)
                            .padding(.trailing, 4)
                    }
                    
                    Text(TimestampDateFormatter.formatDate(comment.time))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button {
                        // 버튼 액션
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.white)
                    }
                }
                
                Text(comment.content)
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
            }
        }
        .navigationDestination(isPresented: $isUserLoaded) {
            // 'user'가 nil이 아닌 경우에만 OtherUserProfileView를 렌더링합니다.
            if let user = user {
                OtherUserProfileView(user: user)
            }
        }
    }
}
