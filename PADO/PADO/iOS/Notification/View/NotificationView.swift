//
//  NotificationView.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI
// TODO: 알림 없으면 noItemView
struct NotificationView: View {
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var notiVM = NotificationViewModel.shared
    
    @State private var fetchedNotiData: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        HStack {
                            Spacer()
                            
                            Button {
                                Task {
                                    await notiVM.deleteAllNotifications()
                                }
                            } label: {
                                Text("알림 전체삭제")
                                    .font(.system(.footnote))
                                    .foregroundStyle(Color(.systemGray))
                            }
                            .padding(.horizontal, 10)
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        if fetchedNotiData {
                            ForEach(notiVM.notifications.indices, id: \.self) { index in
                                NotificationCell(feedVM: feedVM,
                                                 notification: notiVM.notifications[index])
                                .id(index)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .onAppear {
                                    if index == notiVM.notifications.indices.last {
                                        Task {
                                            await notiVM.fetchMoreNotifications()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 0)
                Spacer()
            }
        }
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
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(.body))
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
                fetchedNotiData = true
                enteredNavigation = true
            }
        }
        .onChange(of: resetNavigation) { _, _ in
            dismiss()
        }
        .onDisappear {
            notiVM.stopAllPostListeners()
            enteredNavigation = false
        }
    }
}

