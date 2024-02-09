//
//  NotificationView.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject var notiVM: NotificationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        ScrollView(showsIndicators: false) {
                            // 나중에 ForEach로 만들어야함(?) -> 이뤄드림
                            ForEach(notiVM.notifications) { notification in
                                NotificationCell(notification: notification)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                            }
                            .padding(.top, 50)
                        }
                        
                        VStack {
                            ZStack {
                                Text("알림")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16))
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
                    }
                }
            }
        }
        .padding(.top, 10)
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await notiVM.fetchNotifications()
                await notiVM.markNotificationsAsRead()
            }
        }
    }
}

