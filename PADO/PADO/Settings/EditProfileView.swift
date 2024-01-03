//
//  EditProfile.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct EditProfileView: View {
    
    @State var width = UIScreen.main.bounds.width
    
    @State var fullname = ""
    @State var username = ""
    @State var bio = ""
    @State var location = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.white)
                            }
                                
                            Spacer()
                            
                            Text("저장")
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal, width * 0.05)
                        
                        Text("프로필 수정")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Spacer()
                        Rectangle()
                            .frame(width: width * 0.95, height: 0.7)
                            .foregroundStyle(.gray)
                        .opacity(0.3)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    VStack {
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                Image("pp")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(60)
                                
                                ZStack {
                                    ZStack {
                                        Circle()
                                            .frame(width: 34, height: 34)
                                            .foregroundStyle(.black)
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.white)
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(.black)
                                            .opacity(0.1)
                                    }
                                    
                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 16))
                                        .shadow(color: .white, radius: 1, x: 1, y: 1)
                                }
                            }
                        }
                        // Menu
                        VStack {
                            Rectangle()
                                .frame(width: width * 0.9, height: 0.7)
                                .foregroundStyle(.gray)
                                .opacity(0.3)
                            
                            HStack {
                                HStack {
                                    Text("이름")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("", text: $fullname)
                                        .font(.system(size: 16))
                                        .placeholder(when: fullname.isEmpty) {
                                            Text("천랑성")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            Rectangle()
                                .frame(width: width * 0.9, height: 0.7)
                                .foregroundStyle(.gray)
                                .opacity(0.3)
                                .padding(.top, 4)
                            
                            HStack {
                                HStack {
                                    Text("사용자 이름")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("", text: $username)
                                        .font(.system(size: 16))
                                        .placeholder(when: username.isEmpty) {
                                            Text("kangciu")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            Rectangle()
                                .frame(width: width * 0.9, height: 0.7)
                                .foregroundStyle(.gray)
                                .opacity(0.3)
                                .padding(.top, 4)
                            
                            HStack(alignment: .top) {
                                HStack {
                                    Text("소개")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .padding(.leading, -4)
                                .padding(.top, 4)
                                .frame(width: width * 0.2)
                                
                                    TextEditor(text: $bio)
                                        .foregroundStyle(.white)
                                        .background(.black)
                                        .scrollContentBackground(.hidden) // iOS 16 버전 이상부터 지원함 15 버전 일시 if #available(iOS 16, *)
                                        .frame(height: 100)
                                        .padding(.leading, width * 0.05)
                                        .overlay {
                                            VStack {
                                                HStack {
                                                    if bio.isEmpty {
                                                        Text("소개")
                                                            .foregroundStyle(.gray)
                                                            .font(.system(size: 16))
                                                            .zIndex(1)
                                                            .padding(.top, 8)
                                                            .padding(.leading, 24)
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                        .padding(.top, -4)
                                        .frame(width: width * 0.63)
                                
                            }
                            
                            Rectangle()
                                .frame(width: width * 0.9, height: 0.7)
                                .foregroundStyle(.gray)
                                .opacity(0.3)
                            
                            HStack {
                                HStack {
                                    Text("위치")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.22)
                                
                                HStack {
                                    TextField("", text: $location)
                                        .font(.system(size: 16))
                                        .placeholder(when: location.isEmpty) {
                                            Text("위치")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 16))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.leading, width * 0.05)
                                    
                                    Spacer()
                                }
                                .frame(width: width * 0.63)
                            }
                            .padding(.top, 4)
                            
                            Rectangle()
                                .frame(width: width * 0.9, height: 0.7)
                                .foregroundStyle(.gray)
                                .opacity(0.3)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, width * 0.05)
                        .padding(.top, 24)
                        
                        Spacer()
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.08)
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
