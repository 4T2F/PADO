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
    
    var body: some View {
        HStack(alignment: .top) {

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

            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    Text(comment.userID)
                        .fontWeight(.semibold)
                        .font(.caption)
                        .padding(.trailing, 4)
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
    }
}
