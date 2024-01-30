//
//  FollowerCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct FollowerCell: View {
    
    @State private var buttonActive: Bool = false
    @State var name = ""
    
    var body: some View {
        HStack {
            Image("pp2")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(60/2)
            
            VStack(alignment: .leading) {
                Text("\(name)님이 회원님을 팔로우 하기 시작했습니다.")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            BlueButtonView(cellUserId: "", activeText: "팔로우", unActiveText: "팔로잉", widthValue: 83, heightValue: 32)
        }
        .padding(.horizontal)
    }
}

#Preview {
    FollowerCell(name: "official_tuna")
}
