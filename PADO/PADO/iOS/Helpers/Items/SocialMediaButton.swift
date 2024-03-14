//
//  SocialMediaButton.swift
//  PADO
//
//  Created by 강치우 on 3/8/24.
//

import SwiftUI

struct SocialMediaButton: View {
    let platformName: String
    let urlScheme: String
    let fallbackURL: String

    var body: some View {
        Button {
            openSocialMediaApp(urlScheme: urlScheme, fallbackURL: fallbackURL)
        } label: {
            Image(platformName)
        }
    }

    private func openSocialMediaApp(urlScheme: String, fallbackURL: String) {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: fallbackURL) {
            UIApplication.shared.open(url)
        }
    }
}
