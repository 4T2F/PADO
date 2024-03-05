//
//  HeartNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct HeartNotificationCell: View {
    @ObservedObject var feedVM: FeedViewModel
    @StateObject var notiVM = NotificationViewModel()

    @State private var showPost = false
    
    var notification: Noti
    
    var body: some View {
        Button {
            showPost = true
        } label: {
            HStack(spacing: 0) {
                if let imageUrl = notiVM.notiUser[notification.sendUser]?.profileImageUrl,
                   let image = URL(string: imageUrl) {
                    KFImage(image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        .padding(.trailing)
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(40)
                        .padding(.trailing)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(notification.sendUser)님이 회원님의 파도에 ❤️로 공감했습니다. ")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        +
                        Text(notification.createdAt.formatDate(notification.createdAt))
                            .font(.system(.footnote))
                            .foregroundStyle(Color(.systemGray))
                    }
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                }
                Spacer()
                
            }
        }
        .sheet(isPresented: $showPost) {
            if let postID = notification.postID,
               let post = notiVM.notiPost[postID] {
                   SelectPostCell(feedVM: feedVM, post: .constant(post))
                    .presentationDragIndicator(.visible) // .constant를 사용하여 Binding 객체 생성
               }
        }
    }
}
