//
//  DeleteMessageView.swift
//  PADO
//
//  Created by 최동호 on 2/10/24.
//

import SwiftUI

struct DeleteMessageView: View {
    @Environment (\.dismiss) var dismiss
    @ObservedObject var postitVM: PostitViewModel
    
    let messageID: String
    let text: String
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack(spacing: 10) {
                    
                    Text("방명록 글 삭제")
                        .font(.system(.body))
                        .fontWeight(.semibold)
                    
                    Text("작성한 글을 삭제 할까요?")
                }
                .foregroundStyle(Color.white)
                .font(.system(.subheadline))
                .fontWeight(.medium)
                .padding()
                
                Divider()
                
                Button {
                    Task {
                        await postitVM.removeMessageData(ownerID: postitVM.ownerID,
                                                         messageID: messageID)
                        postitVM.showdeleteModal = false
                    }
                } label: {
                    Text("삭제")
                        .font(.system(.body))
                        .foregroundStyle(Color.red)
                        .fontWeight(.semibold)
                        .frame(width: width * 0.9, height: 40)
                }
                .padding(.bottom, 5)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 22))
            
            VStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(.body))
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                        .frame(width: width * 0.9, height: 40)
                }
            }
            .frame(width: width * 0.9, height: 50)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 12))
        }
        .background(ClearBackground())
    }
}
