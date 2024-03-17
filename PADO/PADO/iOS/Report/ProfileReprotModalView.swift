//
//  ProfileReprotModalView.swift
//  PADO
//
//  Created by 강치우 on 2/10/24.
//

import SwiftUI

struct ReprotProfileModalView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var profileVM: ProfileViewModel
    
    @State private var isShowingReportView: Bool = false
    
    let user: User
    
    var body: some View {
        ZStack {
            Color.modal.ignoresSafeArea()
            VStack {
                VStack {
                    Button {
                        Task {
                            if profileVM.isUserBlocked {
                                // 차단 해제 로직
                                if let currentUser = viewModel.currentUser {
                                    await profileVM.unblockUser(blockingUser: user,
                                                          user: currentUser)
                                    profileVM.isUserBlocked = false
                                }
                            } else {
                                // 차단 로직
                                if let currentUser = viewModel.currentUser {
                                    await profileVM.blockUser(blockingUser: user,
                                                        user: currentUser)
                                    profileVM.isUserBlocked = true
                                    needsDataFetch.toggle()
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(profileVM.isUserBlocked ? "차단 해제" : "차단")
                                .font(.system(.body))
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                             
                            Spacer()
                            
                            Image(systemName: "person.slash")
                                .foregroundStyle(.red)
                                .font(.system(.subheadline))
                                .fontWeight(.bold)
                        }
                    }
                    .onAppear {
                        Task {
                            await profileVM.fetchBlockUsers()
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 6)
                    
                    Button {
                        isShowingReportView.toggle()
                    } label: {
                        HStack {
                            Text("신고")
                                .font(.system(.body))
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            
                            Spacer()
                            
                            Image(systemName: "exclamationmark.bubble")
                                .foregroundStyle(.red)
                                .font(.system(.body))
                                .fontWeight(.semibold)
                        }
                        .sheet(isPresented: $isShowingReportView) {
                            ReportUserView(isShowingReportView: $isShowingReportView)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
                .padding()
                .background(.modalCell)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.vertical, 25)
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("취소")
                            .font(.system(.body))
                            .fontWeight(.bold)
                         
                        Spacer()
                    }
                }
                .padding()
                .background(.modalCell)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 20)
        }
    }
}
