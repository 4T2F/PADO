//
//  BirthAlertModal.swift
//  PADO
//
//  Created by 최동호 on 2/8/24.
//

import SwiftUI

struct BirthAlertModal: View {
    
    var body: some View {
        ZStack {
            Color.main.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 15, content: {
                Text("파도는 만 14세 이상만 이용 가능해요")
                    .font(.system(size: 24))
                    .fontWeight(.heavy)
                    .padding(.top, 5)

            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)

        }
    }
}
