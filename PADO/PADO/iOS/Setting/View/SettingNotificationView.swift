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
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("알림")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image("dismissArrow")
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                
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
                .padding(.top, 50)
            }
        }
        .padding(.top, 10)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            noti = viewModel.currentUser?.alertAccept == "yes" ? true : false
        }
    }
}
