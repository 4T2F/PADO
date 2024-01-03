//
//  SearchBar.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .padding(8)
                .frame(height: 55)
                .padding(.horizontal, 30)
                .foregroundStyle(.white)
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .cornerRadius(8)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .frame(minWidth: 0, maxWidth: 25, alignment: .leading)
                        
                        Text(text.isEmpty ? "친구 추가 또는 검색" : "")
                            .foregroundStyle(.gray)
                            .padding(.leading, -4)
                        
                        Spacer()
                    }
                    .padding(.leading, 10)
                }
            
            if isEditing {
                Button {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.endEditing()
                } label: {
                    Text("취소")
                        .foregroundStyle(.white)
                }
                .padding(.trailing, 4)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            self.isEditing = true
        }
    }
}

#Preview {
    SearchBar(text: .constant(""), isEditing: .constant(true))
}
