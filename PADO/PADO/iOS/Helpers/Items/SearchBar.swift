//
//  SearchBar.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.grayButton
                .frame(width: 270, height: 35)
                .cornerRadius(7)
        
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.gray)
                    .padding(.leading, 10)
                
                TextField("", text: $text,
                          prompt: Text("검색")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray))
                    .padding(7)
                    .padding(.leading, -7)
                    .background(Color.grayButton)
                    .foregroundStyle(Color.white)
                    .accentColor(Color.gray)
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            isEditing = true
                        }
                    }
                    .overlay {
                        HStack {
                            Spacer()
                            if isEditing && !text.isEmpty {
                                if isLoading {
                                    Button {
                                        text = ""
                                    } label: {
                                        ActivityIndicator(style: .medium, animate: .constant(true))
                                        .configure({
                                            $0.color = .white
                                        })
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
                        text = ""
                        isEditing = false
                        hideKeyboard()
                    } label: {
                        Text("취소")
                            .font(.custom("Giants-Bold", size: 15))
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
        }
    }
}

#Preview {
    ZStack{
        Color.white
            .edgesIgnoringSafeArea(.all)
        SearchBar(text: .constant(""), isLoading: .constant(false))
            .padding()
    }
}

