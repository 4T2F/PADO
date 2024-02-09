//
//  MessageBubbleView.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct MessageBubbleView: View {
    let text: String
    let isUser: Bool
    let messageUserID: String
    let messageTime: Timestamp
    let messageID: String
    
    @ObservedObject var postitVM: PostitViewModel
    
    var body: some View {
        VStack(alignment: isUser ? .leading : .trailing) {
            messageBubble(text: text, isUser: isUser)
                .onLongPressGesture(minimumDuration: 1.0) {
                    postitVM.longpressedMessage = text
                    postitVM.longpressedID = messageID
                    if messageUserID == userNameID || postitVM.ownerID == userNameID {
                        postitVM.showdeleteModal.toggle()
                    }
                }
            
            HStack {
                switch isUser {
                case true:
                    Text("\(messageUserID)")
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                        .padding(.trailing, 2)
                    
                    Text("\(messageTime.formatDate(messageTime))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                case false:
                    Text("\(messageTime.formatDate(messageTime))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 2)
                    Text("\(messageUserID)")
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
             
                }
            }
        }
        .sheet(isPresented: $postitVM.showdeleteModal) {
            DeleteMessageView(messageID: postitVM.longpressedID,
                              text: postitVM.longpressedMessage,
                              postitVM: postitVM)
                .presentationDetents([.fraction(0.4)])
        }
    }
    
    func messageBubble(text: String, isUser: Bool) -> some View {
        if isUser {
            return Text(text)
                .font(.system(size: 16))
                .padding(10)
                .background(Color.num3)
                .foregroundColor(.white)
                .clipShape(RoundedCorner(radius: 6, corners: [.topLeft, .topRight, .bottomRight]))
            
        } else {
            return Text(text)
                .font(.system(size: 16))
                .padding(10)
                .background(Color.grayButton)
                .foregroundColor(.white)
                .clipShape(RoundedCorner(radius: 6, corners: [.topLeft, .topRight, .bottomLeft]))
            
        }
    }
}
