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
    @State private var isShowingLoginPage: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Divider()
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            if !postitVM.messages.isEmpty {
                                ForEach(postitVM.messages) { message in
                                    if postitVM.messageUsers.keys.contains(message.messageUserID) {
                                        PostitCell(postitVM: postitVM,
                                                   message: message)
                                        .id(message.id)
                                    }
                                }
                                .onAppear {
                                    if let lastMessageID = postitVM.messages.last?.id {
                                        withAnimation {
                                            proxy.scrollTo(lastMessageID, anchor: .bottom)
                                        }
                                    }
                                }
                            } else {
                                Text("아직 방명록에 글이 없습니다")
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .padding(.top, 150)
                            }
                        }
                        .padding(.top)
                    }
                   
                }
                Divider()
                
                HStack {
                    if let user = viewModel.currentUser {
                        CircularImageView(size: .small, user: user)
                    }
                    
                    HStack {
                        if postitVM.ownerID == userNameID {
                            TextField("내 방명록에 글 남기기",
                                      text: $postitVM.inputcomment,
                                      axis: .vertical)
                            .font(.system(size: 14))
                            .tint(Color(.systemBlue).opacity(0.7))
                            .focused($isTextFieldFocused)
                            
                        } else {
                            TextField("\(postitVM.ownerID)님의 방명록에 글 남기기",
                                      text: $postitVM.inputcomment,
                                      axis: .vertical)
                            .font(.system(size: 14))
                            .tint(Color(.systemBlue).opacity(0.7))
                            .focused($isTextFieldFocused)
                        }
                        
                        if !postitVM.inputcomment.isEmpty {
                            Button {
                                if userNameID.isEmpty {
                                    isShowingLoginPage = true
                                } else if !blockPostit(id: postitVM.ownerID) {
                                    Task {
                                        await postitVM.writeMessage(ownerID: postitVM.ownerID,
                                                                    imageUrl: viewModel.currentUser?.profileImageUrl ?? "",
                                                                    inputcomment: postitVM.inputcomment)
                                        if let user = postitVM.messageUsers[postitVM.ownerID], let currentUser = viewModel.currentUser {
                                            await UpdatePushNotiData.shared.pushNoti(receiveUser: user, type: .postit, sendUser: currentUser)
                                        }
                                    }
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
                            .sheet(isPresented: $isShowingLoginPage, content: {
                                StartView()
                                    .presentationDragIndicator(.visible)
                            })
                        } else {
                            Button {

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
                .padding([.horizontal, .vertical], 8)
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("방명록")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task{
                    await postitVM.getMessageDocument(ownerID: postitVM.ownerID)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingMessageView = false
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                            
                            Text("닫기")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
        }
    }
    private func blockPostit(id: String) -> Bool {
        let blockedUserIDs = Set(blockingUser.map { $0.blockUserID } + blockedUser.map { $0.blockUserID })
        
        return blockedUserIDs.contains(id)
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

