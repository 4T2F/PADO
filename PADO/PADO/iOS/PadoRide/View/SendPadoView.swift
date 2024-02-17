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
    @State private var postLoading = false
    
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
                if !postLoading {
                    postLoading = true
                    Task {
                        await padorideVM.sendPostAtFirebase()
                        padorideVM.showingModal = false
                        padorideVM.cancelImageEditing()
                        postLoading = false
                        padorideVM.isShowingEditView = false
                        if let selectedPost = padorideVM.selectedPost, let surfingUser = surfingUser {
                            await UpdatePushNotiData.shared.pushPostNoti(targetPostID: selectedPost.id ?? "",
                                                                         receiveUser: surfingUser,
                                                                         type: .padoRide,
                                                                         message: "",
                                                                         post: selectedPost)
                        }
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .foregroundStyle(.blueButton)
                    
                    if postLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else {
                        Text("보내기")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
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
