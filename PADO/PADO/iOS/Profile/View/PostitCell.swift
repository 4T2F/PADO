//
//  PostitCell.swift
//  PADO
//
//  Created by 최동호 on 2/11/24.
//

import Kingfisher
import SwiftUI

struct PostitCell: View {
    
    @ObservedObject var postitVM: PostitViewModel
    @State private var buttonOnOff: Bool = false
    
    let message: PostitMessage
    
    var body: some View {
            HStack {
                if message.messageUserID == postitVM.ownerID {
                    
                    if let user = postitVM.messageUsers[message.messageUserID] {
                        NavigationLink {
                            OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                 user: user)
                        } label: {
                            UrlProfileImageView(imageUrl: user.profileImageUrl ?? "",
                                                size: .medium,
                                                defaultImageName: "defaultProfile")
                        }
                        if let messageID = message.id {
                            MessageBubbleView(text: message.content,
                                              isUser: true,
                                              messageUserID: message.messageUserID,
                                              messageTime: message.messageTime,
                                              messageID: messageID,
                                              postitVM: postitVM)
                        }
                        Spacer()
                        
                    }
                } else {
                    Spacer()
                    if let messageID = message.id {
                        MessageBubbleView(text: message.content,
                                          isUser: false,
                                          messageUserID: message.messageUserID,
                                          messageTime: message.messageTime,
                                          messageID: messageID,
                                          postitVM: postitVM)
                    }
                    if let user = postitVM.messageUsers[message.messageUserID] {
                        NavigationLink {
                            OtherUserProfileView(buttonOnOff: $buttonOnOff,
                                                 user: user)
                        } label: {
                            UrlProfileImageView(imageUrl: user.profileImageUrl ?? "",
                                                size: .medium,
                                                defaultImageName: "defaultProfile")
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
     
        .onAppear {
            self.buttonOnOff = UpdateFollowData.shared.checkFollowingStatus(id: message.messageUserID)
        }
    }
    
}
