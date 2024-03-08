//
//  PostGridView.swift
//  PADO
//
//  Created by 강치우 on 3/8/24.
//

import Kingfisher

import SwiftUI

struct PostGridView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var feedVM: FeedViewModel
    
    var columns: [GridItem]
    var posts: [Post]
    var fetchedData: Bool
    var showingDetail: Binding<Bool>
    

    var body: some View {
        // 여기에는 postList() 함수의 내용을 기반으로 한 그리드 뷰를 옮깁니다.
        // 예를 들어:
        VStack(spacing: 25) {
            // 이곳에 VStack의 내용을 넣습니다.
        }
    }
}
