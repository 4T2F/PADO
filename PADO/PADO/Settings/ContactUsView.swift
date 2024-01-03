//
//  ContactUsView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct ContactUsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack(spacing: 20) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 45)
                                        .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                                    
                                    HStack {
                                        Image(systemName:  "questionmark.circle")
                                            .foregroundStyle(.white)
                                        
                                        Text("질문 하기")
                                    }
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                }
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 45)
                                        .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                                    
                                    HStack {
                                        Image(systemName:  "ladybug")
                                            .foregroundStyle(.white)
                                        
                                        Text("문제 보고")
                                    }
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                }
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 45)
                                        .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                                    
                                    HStack {
                                        Image(systemName:  "pencil.line")
                                            .foregroundStyle(.white)
                                        
                                        Text("아이디어나 피드백이 있으십니까?")
                                    }
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                }
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 45)
                                        .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                                    
                                    HStack {
                                        Image(systemName:  "tray.fill")
                                            .foregroundStyle(.white)
                                        
                                        Text("메시지")
                                    }
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 50)
                    }
                    
                    VStack {
                        ZStack {
                            Text("문의하기")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20))
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    ContactUsView()
}
