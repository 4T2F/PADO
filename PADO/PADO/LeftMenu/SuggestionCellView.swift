//
//  SuggestionCellView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct SuggestionCellView: View {
    var body: some View {
        HStack {
            Image("pp1")
                .resizable()
                .frame(width: 65, height: 65)
                .cornerRadius(65/2)
            
            VStack(alignment: .leading) {
                Text("뇽뇽")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                Text("pinkso")
                    .foregroundStyle(.gray)
                
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    Text("이민영")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                        .padding(.leading, -4)
                }
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(red: 44/255, green: 44/255, blue: 46/255))
                .frame(width: 45, height: 25)
                .overlay {
                    Text("추가")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                }
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
                .padding(.leading, 6)
        }
        .padding(.horizontal)
    }
}

#Preview {
    SuggestionCellView()
}
