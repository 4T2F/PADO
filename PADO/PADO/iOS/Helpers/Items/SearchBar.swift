//
//  SearchBar.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isLoading: Bool
    
    @State private var isEditing = false
    @State var isFocused: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.gray)
                        .padding(.leading, 10)
                    
                    RepresentableTextField(placeHolderString: "검색", keyboardType: .default, text: $text, isFocused: $isFocused)
                    .tint(.gray)
                    .frame(height: 20)
                    .padding(8)
                    .padding(.leading, -7)
                    .foregroundStyle(Color.white)
                    .accentColor(Color.gray)
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            isEditing = true
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10) // HStack의 크기에 맞게 동적으로 크기가 변하는 RoundedRectangle
                        .fill(Color.gray.opacity(0.3))
                )
                .overlay {
                    HStack {
                        Spacer()
                        if isEditing && !text.isEmpty {
                            if isLoading {
                                Button {
                                    text = ""
                                } label: {
                                    ProgressView()
                                }
                                .padding(.trailing, 15)
                                .frame(width: 35, height: 35)
                            } else {
                                Button(action: {
                                    text = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Color.gray)
                                        .frame(width: 35, height: 35)
                                }
                                .padding(.trailing, 5)
                            }
                        }
                    }
                }
                if isEditing {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            text = ""
                            isEditing = false
                            hideKeyboard()
                        }
                    } label: {
                        Text("취소")
                            .font(.custom("Giants-Bold", size: 15))
                            .foregroundStyle(Color.white)
                    }
                    .padding(3)
                }
            }
        }
    }
}
