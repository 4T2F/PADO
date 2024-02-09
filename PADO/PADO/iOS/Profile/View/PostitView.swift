//
//  PostitView.swift
//  PADO
//
//  Created by 최동호 on 2/9/24.
//
import Kingfisher
import SwiftUI

struct PostitView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject var postitVM: PostitViewModel
    
    @Binding var isShowingMessageView: Bool
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var isFocused: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    isShowingMessageView = false
                } label: {
                    Text("취소")
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Text("방명록")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .padding(.trailing, 30)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 5)
            
            Divider()
            ScrollView {
                VStack {
                    if !postitVM.messages.isEmpty {
                        ForEach(postitVM.messages) { message in
                            HStack {
                                if message.messageUserID == postitVM.ownerID {
                                    UrlProfileImageView(imageUrl: message.imageUrl,
                                                        size: .medium,
                                                        defaultImageName: "defaultProfile")
                                    if let messageID = message.id {
                                        MessageBubbleView(text: message.content,
                                                          isUser: true,
                                                          messageUserID: message.messageUserID,
                                                          messageTime: message.messageTime,
                                                          messageID: messageID,
                                                          postitVM: postitVM)
                                    }
                                    Spacer()
                                } else {
                                    Spacer()
                                    if let messageID = message.id {
                                        MessageBubbleView(text: message.content,
                                                          isUser: false,
                                                          messageUserID: message.messageUserID,
                                                          messageTime: message.messageTime,
                                                          messageID: messageID,
                                                          postitVM: postitVM)
                                    }
                                    UrlProfileImageView(imageUrl: message.imageUrl,
                                                        size: .medium,
                                                        defaultImageName: "defaultProfile")
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                    } else {
                        Text("아직 방명록에 글이 없어요")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .padding(.top, 150)
                    }
                }
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .offset(y: -7)
        
        HStack {
            if let user = viewModel.currentUser {
                CircularImageView(size: .small, user: user)
            }
            
            HStack {
                if postitVM.ownerID == userNameID {
                    TextField("내 방명록에 글 남기기",
                              text: $postitVM.inputcomment,
                              axis: .vertical)
                        .tint(Color(.systemBlue).opacity(0.7))
                        .focused($isTextFieldFocused)

                } else {
                    TextField("\(postitVM.ownerID)에게 글 남기기",
                              text: $postitVM.inputcomment,
                              axis: .vertical)
                        .tint(Color(.systemBlue).opacity(0.7))
                        .focused($isTextFieldFocused)
                }
                
                if !postitVM.inputcomment.isEmpty {
                    Button {
                        Task {
                            await postitVM.writeMessage(ownerID: postitVM.ownerID,
                                                        imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                        inputcomment: postitVM.inputcomment)
                            
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .frame(width: 48, height: 28)
                                .foregroundStyle(.blue)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.vertical, -5)
                } else {
                    Button {
                        //
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .frame(width: 48, height: 28)
                                .foregroundStyle(.gray)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 14))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
        .padding(.bottom)
        
    }
    
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

