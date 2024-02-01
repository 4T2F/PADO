//
//  PostView.swift
//  PADO
//
//  Created by 김명현 on 1/23/24.
//

import SwiftUI

struct PostView: View {
    // MARK: - PROPERTY
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var profileVM: ProfileViewModel
    
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
                Text("서핑리스트")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.leading, 5)
                
                Spacer()
                
                Button {
                    // 서핑 리스트 추가 로직 구현
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
                Task {
                    do {
                        // 이미지 업로드 시 이전 입력 데이터 초기화
                        let uploadedImageUrl = try await updateImageUrl.updateImageUserData(uiImage: surfingVM.postingUIImage,
                                                                                            storageTypeInput: .post,
                                                                                            documentid: feedVM.documentID,
                                                                                            imageQuality: .highforPost)
                        await surfingVM.postRequest(imageURL: uploadedImageUrl)
                        await profileVM.fetchPadoPosts(id: userNameID)
                        surfingVM.resetImage()
                        feedVM.findFollowingUsers()
                        viewModel.showTab = 0
                    } catch {
                        print("파베 전송 오류 발생: (error.localizedDescription)")
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
        } //: VSTACK
        .navigationBarBackButtonHidden()
    }
}
