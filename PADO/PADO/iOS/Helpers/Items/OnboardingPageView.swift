//
//  OnboardingPageView.swift
//  PADO
//
//  Created by 황성진 on 3/18/24.
//

import SwiftUI

struct OnboardingPageView: View {
    var title: String
    var description: String
    var imageName: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.system(.title3, weight: .medium))
            
            Text(description)
                .foregroundStyle(.white.opacity(0.8))
                .font(.callout)
                .lineSpacing(2)
            
            Image(imageName)
                .padding()
            
            Spacer()
        }
        .padding(.top, 40)
        .multilineTextAlignment(.center)
    }
}
