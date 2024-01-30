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

    @State var imageProfileUrl: String = ""
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var commentVM: CommentViewModel

    var onTap: () -> Void  // 탭 동작을 위한 클로저
    
    var body: some View {
        VStack {
            KFImage.url(URL(string: imageProfileUrl))
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(70)
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
        commentVM.documentID = story.postID
        Task {
            await commentVM.getCommentsDocument()
        }
    }
}
