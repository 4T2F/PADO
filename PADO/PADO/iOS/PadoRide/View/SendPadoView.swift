//
//  SendPadoView.swift
//  PADO
//
//  Created by 황성진 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct SendPadoView: View {
    // MARK: - PROPERTY
    @ObservedObject var padorideVM: PadoRideViewModel
    @State private var surfingUser: User?
    
    @Environment (\.dismiss) var dismiss
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                if let user = surfingUser {
                    CircularImageView(size: .medium, user: user)
                }
                Text("\(padorideVM.selectedPost?.ownerUid ?? "") 님에게 파도타기")
            }
            .padding()
            
            Button {
                padorideVM.showingModal = false
                Task {
                    await padorideVM.sendPostAtFirebase()
                    if let selectedPost = padorideVM.selectedPost, let surfingUser = surfingUser {
                        await UpdatePushNotiData.shared.pushPostNoti(targetPostID: selectedPost.id ?? "",
                                                                     receiveUser: surfingUser,
                                                                     type: .padoRide,
                                                                     message: "",
                                                                     post: selectedPost)
                    }
                    padorideVM.cancelImageEditing()
                    padorideVM.isShowingEditView = false
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .foregroundStyle(.blueButton)
                    
                    Text("보내기")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            Task {
                let returnUser = await UpdateUserData.shared.getOthersProfileDatas(id: padorideVM.selectedPost?.ownerUid ?? "")
                self.surfingUser = returnUser
            }
        }
    }
}
