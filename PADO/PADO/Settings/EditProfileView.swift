//
//  EditProfile.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct EditProfileView: View {
    
    @State var width = UIScreen.main.bounds.width
    
    @State var fullname: String
    @State var username: String
    @State var bio: String
    @State var location: String
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    let currentUser: User
    
    // 사용자의 정보를 초기화하고 currentUser에서 데이터를 가져옴
    init(currentUser: User) {
        self.currentUser = currentUser
        self._fullname = State(initialValue: currentUser.name)
        self._bio = State(initialValue: currentUser.bio ?? "")
        self._username = State(initialValue: currentUser.username ?? "")
        self._location = State(initialValue: currentUser.location ?? "")
    }
    
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
                            
                            Button {
                                Task {
                                    await saveData()
                                }
                                dismiss()
                            } label: {
                                Text("저장")
                                    .foregroundStyle(.gray)
                            }
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
                                Circle()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(60)
                                    .foregroundStyle(Color(red: 152/255, green: 163/255, blue: 16/255))
                                    .overlay {
                                        Text(viewModel.currentUser!.name.prefix(1).uppercased())
                                            .foregroundStyle(.white)
                                            .font(.system(size: 55))
                                    }
                                
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
                                            Text(viewModel.currentUser!.name)
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
                                            Text(viewModel.currentUser!.name.lowercased())
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
                                                    if currentUser.bio == "" {
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
    
    // 사용자 프로필이 변경되면 변경된 값으로 저장하는 함수
    func saveData() async {
        if viewModel.currentUser!.name != self.fullname && !self.fullname.isEmpty {
            viewModel.currentUser!.name = self.fullname
            await viewModel.saveUserData(data: ["name" : self.fullname])
        }
        
        if viewModel.currentUser!.username != self.username && !self.username.isEmpty {
            viewModel.currentUser!.username = self.username
            await viewModel.saveUserData(data: ["username" : self.username])
        }
        
        if viewModel.currentUser!.bio != self.bio && !self.bio.isEmpty {
            viewModel.currentUser!.bio = self.bio
            await viewModel.saveUserData(data: ["bio" : bio])
        }
        
        if viewModel.currentUser!.location != self.location && !self.location.isEmpty {
            viewModel.currentUser!.location = self.location
            await viewModel.saveUserData(data: ["location" : location])
        }
    }
}

//#Preview {
//    EditProfileView()
//}
