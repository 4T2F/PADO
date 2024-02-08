//
//  PostView.swift
//  PADO
//
//  Created by 김명현 on 1/23/24.
//

import Kingfisher
import SwiftUI

struct PostView: View {
    // MARK: - PROPERTY
    @State private var postLoading = false
    @State private var showAlert = false
    @State private var postOwner: User? = nil
    
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @Environment (\.dismiss) var dismiss
    let updateImageUrl = UpdateImageUrl.shared
    
    // MARK: - BODY
    var body: some View {
        VStack {
            ZStack {
                Text("서핑하기")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                
                HStack {
                    Button {
                        if let image = surfingVM.selectedImage {
                            surfingVM.postingUIImage = image
                        }
                        followVM.selectSurfingID = ""
                        followVM.selectSurfingUsername = ""
                        followVM.selectSurfingProfileUrl = ""
                        dismiss()
                    } label: {
                        Image("dismissArrow")
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            
        } //: VSTACK
        .onDisappear {
            surfingVM.postingImage = Image(systemName: "photo")
        }
        
        VStack {
            surfingVM.postingImage
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.5)
                .padding(.vertical, 20)
            
            Spacer()
            
            HStack {
                Text("제목")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.leading, 5)
                
                Spacer()
            } //: HSTACK
            
            .padding(.leading, 20)
            
            TextField("제목을 입력해주세요", text: $surfingVM.postingTitle)
                .font(.system(size: 14))
                .padding(.leading, 20)
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(UIColor.systemGray))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.5)
            
            HStack {
                if followVM.selectSurfingID.isEmpty {
                    Text("서핑리스트")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                } else {
                    KFImage(URL(string: followVM.selectSurfingProfileUrl))
                        .resizable()
                        .placeholder {
                            // 로딩 중이거나 URL이 nil일 때 표시될 이미지
                            Image("defaultProfile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.leading, 5)
                    
                    VStack(alignment: .leading) {
                        Text(followVM.selectSurfingID)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(followVM.selectSurfingUsername)
                            .font(.system(size: 12))
                    }
                    .padding(.leading, 5)
                }
                
                Spacer()
                
                Button {
                    followVM.showSurfingList.toggle()
                } label: {
                    Text("+")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.trailing)
            } //: HSTACK
            .padding(20)
            
            Spacer()
            
            Button {
                // 게시요청 로직
                if followVM.selectSurfingID.isEmpty {
                    // 서핑할 친구가 선택되지 않았을 때 경고 메시지를 표시
                    showAlert = true
                } else {
                    if !postLoading {
                        Task {
                            do {
                                // 이미지 업로드 시 이전 입력 데이터 초기화
                                postLoading = true
                                let uploadedImageUrl = try await updateImageUrl.updateImageUserData(uiImage: surfingVM.postingUIImage,
                                                                                                    storageTypeInput: .post,
                                                                                                    documentid: feedVM.documentID,
                                                                                                    imageQuality: .highforPost, 
                                                                                                    surfingID: followVM.selectSurfingID)
                                await surfingVM.postRequest(imageURL: uploadedImageUrl,
                                                            surfingID: followVM.selectSurfingID)
                                await profileVM.fetchPadoPosts(id: userNameID)
                                await profileVM.fetchSendPadoPosts(id: userNameID)
                                postOwner = await UpdateUserData.shared.getOthersProfileDatas(id: followVM.selectSurfingID)
                                await UpdatePushNotiData.shared.pushPostNoti(targetPostID: formattedPostingTitle, receiveUser: postOwner!, type: .requestSurfing, message: "\($surfingVM.postingTitle)") // 예시 postID 넣어둠
                                surfingVM.resetImage()
                                feedVM.findFollowingUsers()
                                followVM.selectSurfingID = ""
                                followVM.selectSurfingUsername = ""
                                followVM.selectSurfingProfileUrl = ""
                                viewModel.showTab = 0
                                postLoading = false
                            } catch {
                                print("파베 전송 오류 발생: (error.localizedDescription)")
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .foregroundStyle(.blueButton)
                    
                    Text("게시요청")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            } 
            .alert("서핑할 친구를 선택해주세요", isPresented: $showAlert) {
                Button("확인", role: .cancel) { }
            }
        } //: VSTACK
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $followVM.showSurfingList) {
            SurfingSelectView(followVM: followVM)
                .presentationDetents([.medium, .large])
        }
    }
}
