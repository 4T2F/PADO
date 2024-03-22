//
//  SendPadoView.swift
//  PADO
//
//  Created by 황성진 on 2/8/24.
//

import Kingfisher
import SwiftUI

struct SendPadoView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var padorideVM: PadoRideViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let user = padorideVM.surfingUser {
                    CircularImageView(size: .medium, user: user)
                }
                Text("\(padorideVM.selectedPost?.ownerUid ?? "")님에게 파도타기 공유")
                    .font(.system(.body))
                    .fontWeight(.medium)
            }
            .padding(.vertical)
            .padding(.horizontal, 8)
            
            Button {
                if !padorideVM.postLoading {
                    padorideVM.postLoading = true
                    Task {
                        await padorideVM.sendPostAtFirebase()
                        padorideVM.showingModal = false
                        padorideVM.cancelImageEditing()
                        padorideVM.postLoading = false
                        padorideVM.isShowingEditView = false
                        if let selectedPost = padorideVM.selectedPost, let surfingUser = padorideVM.surfingUser {
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
                    
                    if padorideVM.postLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    } else {
                        Text("공유")
                            .font(.system(.body))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .onAppear {
            Task {
                let returnUser = await UpdateUserData.shared.getOthersProfileDatas(id: padorideVM.selectedPost?.ownerUid ?? "")
                padorideVM.surfingUser = returnUser
            }
        }
    }
}
