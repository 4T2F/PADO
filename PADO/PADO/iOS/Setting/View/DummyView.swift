//
//  DummyView.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

import SwiftUI

struct DummyView: View {
    var body: some View {
        ModalAlertView(showingCircleImage: false, mainTitle: .account, subTitle: .account, removeMessage: .account)
    }
}

struct followerAlertView: View {
    var body: some View {
        ModalAlertView(showingCircleImage: true, mainTitle: .follower, subTitle: .follower, removeMessage: .follower)
    }
}

#Preview {
    followerAlertView()
}
