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
    
    var story: Story
    var storyIndex: Int
    var isWatched: Bool {
        feedVM.watchedPostIDs.contains(story.postID)
    }
    
    @State var imageProfileUrl: String = ""
    @ObservedObject var feedVM: FeedViewModel

    var onTap: () -> Void  // 탭 동작을 위한 클로저
    
    var body: some View {
        VStack {
            if isWatched {
                ZStack {
                    Circle()
                        .stroke(.gray, lineWidth: 1.4)
                        .foregroundColor(.black)
                        .background(.clear)
                        .frame(width: 72, height: 72)
                    
                    KFImage.url(URL(string: imageProfileUrl))
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
                        .frame(width: 72, height: 72)
                    
                    KFImage.url(URL(string: imageProfileUrl))
                        .resizable()
                        .frame(width: 66, height: 66)
                        .cornerRadius(70)
                }
                .padding(.top, 5)
            }

            Text(story.name)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        .onAppear {
            Task {
                imageProfileUrl = await feedVM.setupProfileImageURL(id: story.name)

            }
        }
        .onTapGesture {
            onTap()  // 텍스트를 탭했을 때 클로저 호출
            setFeedData()
        }
    }
    
    func setFeedData() {
        feedVM.feedProfileID = story.name
        feedVM.feedProfileImageUrl = imageProfileUrl
        feedVM.selectedFeedTitle = story.title
        feedVM.selectedFeedTime = TimestampDateFormatter.formatDate(story.postTime)
        feedVM.selectedFeedHearts = story.hearts
        feedVM.documentID = story.postID
        Task {
            await feedVM.getCommentsDocument()
        }
    }
}
