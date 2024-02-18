//
//  SettingNotificationView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingNotificationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @Environment (\.dismiss) var dismiss
    @State var noti: Bool = true
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    VStack {
                        SettingToggleCell(icon: "square.and.pencil", text: "알림 설정", toggle: $noti)
                            .onChange(of: noti) { oldValue, newValue in
                                Task {
                                    await viewModel.updateAlertAcceptance(newStatus: newValue)
                                }
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
        .onAppear {
            noti = viewModel.currentUser?.alertAccept == "yes" ? true : false
        }
    }
}
