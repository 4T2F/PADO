//
//  MainCommentCell.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct MainCommentCell: View {
    let mainComment: MainComment
    
    var body: some View {
        HStack {
            // 유저의 프로필 사진 받아와야함 프로필 사진이 없으면 기본 프사로 적용되게 해야함
            Circle()
                .fill(Color.gray)
                .frame(width: 30, height: 30)
                .overlay(
                    Text(mainComment.nameID.prefix(1))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )
            // 댓글 받아와야함
            Text(mainComment.comment)
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
        
    }
}

