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
            Color.modal.ignoresSafeArea()
            VStack(alignment: .leading, content: {
                Text("회원가입이 불가능합니다")
                    .font(.system(.title))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color(.systemRed))
                    .padding(.top, 5)
                Text("파도는 만 14세 이상만 이용 가능합니다.")
                    .font(.system(.title2))
                    .fontWeight(.heavy)
                    .padding(.top)
            })
            .padding()

        }
    }
}
