//
//  PhotoMojiCell.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//
import Kingfisher
import SwiftUI

struct PhotoMojiCell: View {
    @ObservedObject var commentVM: CommentViewModel
    
    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
    var photoMoji: PhotoMoji
    
    var body: some View {
        if photoMoji.userID == userNameID {
            VStack {
                ZStack {
                    Circle()
                        .stroke(emojiColors[photoMoji.emoji, default: .white], lineWidth: 1.4)
                        .frame(width: 56, height: 56)
                    
                    KFImage(URL(string: photoMoji.faceMojiImageUrl))
                        .fade(duration: 0.5)
                        .placeholder{
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())
                        .onLongPressGesture(minimumDuration: 1) {
                            hapticImpact.impactOccurred()
                            commentVM.selectedPhotoMoji = photoMoji
                            commentVM.deletePhotoMojiModal = true
                        }
                    
                    Text(photoMoji.emoji)
                        .offset(x: 20, y: 20)
                }
                
                Text(photoMoji.userID)
                    .foregroundStyle(.white)
                    .font(.system(.footnote))
            }
        } else {
            VStack {
                ZStack {
                    Circle()
                        .stroke(emojiColors[photoMoji.emoji, default: .white], lineWidth: 1.4)
                        .frame(width: 56, height: 56)
                    
                    KFImage(URL(string: photoMoji.faceMojiImageUrl))
                        .fade(duration: 0.5)
                        .placeholder{
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())
                    
                    Text(photoMoji.emoji)
                        .offset(x: 20, y: 20)
                }
                
                Text(photoMoji.userID)
                    .foregroundStyle(.white)
                    .font(.system(.footnote))
            }
        }
    }
}
