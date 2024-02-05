//
//  StoryCell.swift
//  PADO
//
//  Created by 강치우 on 1/20/24.
//

import Firebase
import FirebaseFirestoreSwift
import Kingfisher
import SwiftUI

struct StoryCell: View {
    
    var story: Post
    var storyIndex: Int
    var isWatched: Bool {
        feedVM.watchedPostIDs.contains(story.id ?? "")
    }
    
    var isWatching: Bool  {
        feedVM.selectedPostID == story.id
    }
    
    @State var ownerProfileUrl: String = ""
    @State var surferProfileUrl: String = ""
    @ObservedObject var feedVM: FeedViewModel

    var onTap: () -> Void  // 탭 동작을 위한 클로저
    
    var body: some View {
        VStack {
            if isWatching {
                ZStack {
                    Circle()
                        .fill(.clear)
                        .stroke(.white, lineWidth: 1.6)
                        .foregroundColor(.black)
                        .frame(width: 70, height: 70)
                    
                    KFImage.url(URL(string: ownerProfileUrl))
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
                .padding(.top, 5)

            } else if isWatched {
                ZStack {
                    Circle()
                        .fill(.black)
                        .stroke(.gray, lineWidth: 1.4)
                        .foregroundColor(.black)
                        .frame(width: 70, height: 70)
                    
                    KFImage.url(URL(string: ownerProfileUrl))
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
                .padding(.top, 5)
            } else {
                ZStack {
                    Circle()
                        .stroke(LinearGradient(colors: [.num1, .num2, .num3, .num3, .num2, .num1], startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 2.3)
                        .foregroundColor(.black)
                        .background(.clear)
                        .frame(width: 70, height: 70)
                    
                    KFImage.url(URL(string: ownerProfileUrl))
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
                .padding(.top, 5)
            }

            Text(story.ownerUid)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        .onAppear {
            Task {
                ownerProfileUrl = await feedVM.setupProfileImageURL(id: story.ownerUid)
                surferProfileUrl = await feedVM.setupProfileImageURL(id: story.surferUid)

            }
        }
        .onTapGesture {
            onTap()  // 텍스트를 탭했을 때 클로저 호출
            setFeedData()
        }
    }
    
    func setFeedData() {
        feedVM.feedOwnerProfileID = story.ownerUid
        feedVM.feedOwnerProfileImageUrl = ownerProfileUrl
        feedVM.feedSurferProfileID = story.surferUid
        feedVM.feedSurferProfileImageUrl = surferProfileUrl
        feedVM.selectedFeedTitle = story.title
        feedVM.selectedFeedTime = TimestampDateFormatter.formatDate(story.created_Time)
//        feedVM.selectedFeedHearts = story.heartsCount
        if let postID = story.id {
            feedVM.documentID = postID
        }
//        Task {
//            await feedVM.getCommentsDocument()
//        }
    }
}
