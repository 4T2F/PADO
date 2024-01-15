//
//  SocialView.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import SwiftUI

struct SocialGlobeView: View {
    // MARK: - PROPERY
    
    // MARK: - BODY
    var body: some View {
        Image(systemName: "globe")
            .resizable()
            .scaledToFit()
            .frame(width: 36, height: 36)
            .foregroundStyle(.white)
            .padding()
            .background(
                Circle()
                    .foregroundStyle(Color.black)
            )
    }
}

#Preview {
    SocialGlobeView()
}
