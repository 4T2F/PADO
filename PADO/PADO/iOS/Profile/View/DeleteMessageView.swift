//
//  DeleteMessageView.swift
//  PADO
//
//  Created by 최동호 on 2/10/24.
//

import SwiftUI

struct DeleteMessageView: View {
    let messageID: String
    let text: String
    
    @ObservedObject var postitVM: PostitViewModel
    var body: some View {
        VStack {
            Text("방명록 글 삭제")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            VStack {
                Text("\(text) 를")
                    .font(.system(size: 16))
                    .lineLimit(2)
                    .padding()
                
                Text("삭제 하시겠습니까?")
                    .font(.system(size: 16))
                    .padding()
                
                Button {
                    Task {
                        await postitVM.removeMessageData(ownerID: postitVM.ownerID,
                                                            messageID: messageID)
                        postitVM.showdeleteModal = false
                    }
                   
                } label: {
                    Text("삭제")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.red)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
                
                Button {
                    postitVM.showdeleteModal = false
                } label: {
                    Text("취소")
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.grayButton)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        )
                }
                .padding()
            }
        }
        .padding()
    }
}
