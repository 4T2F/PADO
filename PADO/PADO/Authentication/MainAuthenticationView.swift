//
//  MainAuthenticationView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct MainAuthenticationView: View {
    
    @State private var nameButtonClicked = false
    @State private var ageButtonClicked = false
    @State private var phoneNumberButtonClicked = false
    
    var body: some View {
        NavigationStack {
            if !nameButtonClicked {
                EnterNameView(nameButtonClicked: $nameButtonClicked)
            } else if nameButtonClicked && !ageButtonClicked {
                EnterAgeView(ageButtonClicked: $ageButtonClicked)
            } else if nameButtonClicked && ageButtonClicked && !phoneNumberButtonClicked {
                EnterPhoneNumberView(phoneNumberButtonClicked: $phoneNumberButtonClicked)
            }
        }
    }
}

#Preview {
    MainAuthenticationView()
}
