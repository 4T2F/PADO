//
//  CreateFeedCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct CreateFeedCell: View {
    
    @State private var buttonActive: Bool = false
    @State var name = ""
    
    var body: some View {
        HStack {
            Image("pp1")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(60/2)
            
            VStack(alignment: .leading) {
                Text("\(name)님이 회원님의 피드를 작성했어요. 확인해주세요!")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            Image("front")
                .resizable()
                .frame(width: 50, height: 60)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CreateFeedCell(name: "official_tuna")
}
