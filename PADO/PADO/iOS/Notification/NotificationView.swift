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
            VStack {
                ScrollView(showsIndicators: false) {
                    // 나중에 ForEach로 만들어야함(?) -> 이뤄드림
                    ForEach(notiVM.notifications) { notification in
                        NotificationCell(notification: notification)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                    }
                    .padding(.top)
                }
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("문의하기")
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
            Task {
                await notiVM.fetchNotifications()
                await notiVM.markNotificationsAsRead()
            }
        }
    }
}

