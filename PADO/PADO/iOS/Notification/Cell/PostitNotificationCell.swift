//
//  PostitNotificationCell.swift
//  PADO
//
//  Created by 황민채 on 2/12/24.
//

import Kingfisher
import SwiftUI

struct PostitNotificationCell: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    @ObservedObject var notiVM: NotificationViewModel
    
    @Environment(\.dismiss) var dismiss

    var notification: Noti
    var openPostit: () -> Void
    
    var body: some View {
        if let user = notiVM.notiUser[notification.sendUser] {
            Button {
                Task {
                    dismiss()
                    try? await Task.sleep(nanoseconds: 1 * 500_000_000)
                    viewModel.showTab = 4
                    try? await Task.sleep(nanoseconds: 1 * 250_000_000)
                    openPostit()
                }
            } label: {
                HStack(spacing: 0) {
                    CircularImageView(size: .medium,
                                      user: user)
                    .padding(.trailing, 10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(notification.sendUser)님이 회원님의 방명록에 글을 남겼습니다. ")
                                .font(.system(.subheadline))
                                .fontWeight(.medium)
                            +
                            Text(notification.createdAt.formatDate(notification.createdAt))
                                .font(.system(.footnote))
                                .foregroundStyle(Color(.systemGray))
                        }
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                    }
                    
                    Spacer()
                    
                }
            }
        }
    }
}
