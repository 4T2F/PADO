//
//  MessageBubbleView.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//

import FirebaseFirestore

import SwiftUI

struct MessageBubbleView: View {
    @ObservedObject var postitVM: PostitViewModel
    
    let text: String
    let isUser: Bool
    let messageUserID: String
    let messageTime: Timestamp
    let messageID: String
    
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
                        .fontWeight(.medium)
                        .font(.system(.subheadline))
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
                        .fontWeight(.medium)
                        .font(.system(.subheadline))
                        .foregroundStyle(.white)
             
                }
            }
        }
        .sheet(isPresented: $postitVM.showdeleteModal) {
            DeleteMessageView(postitVM: postitVM, messageID: postitVM.longpressedID,
                              text: postitVM.longpressedMessage)
                .presentationDetents([.fraction(0.4)])
        }
    }
    
    func messageBubble(text: String, isUser: Bool) -> some View {
        if isUser {
            return Text(text)
                .font(.system(.body))
                .padding(10)
                .background(Color.num3)
                .foregroundColor(.white)
                .clipShape(RoundedCorner(radius: 6, corners: [.topLeft, .topRight, .bottomRight]))
            
        } else {
            return Text(text)
                .font(.system(.body))
                .padding(10)
                .background(Color.grayButton)
                .foregroundColor(.white)
                .clipShape(RoundedCorner(radius: 6, corners: [.topLeft, .topRight, .bottomLeft]))
            
        }
    }
}
