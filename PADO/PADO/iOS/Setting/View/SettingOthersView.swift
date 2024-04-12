//
//  SettingOthers.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import FirebaseFirestore

import SwiftUI

struct SettingOthersView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @Environment (\.dismiss) var dismiss
    
    @State var savePhoto: Bool = UserDefaults.standard.bool(forKey: "savePhoto")
    @State private var showingCashModal: Bool = false
    @State private var showingDeleteModal: Bool = false
    
    @Binding var openHighlight: Bool
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    SettingToggleCell(toggle: $savePhoto,
                                      icon: "photo.badge.plus",
                                      text: "파도타기 갤러리 저장")
                        .onChange(of: savePhoto) { _, newValue in
                            UserDefaults.standard.set(newValue, forKey: "savePhoto")
                        }
                    
                    SettingToggleCell(toggle: $openHighlight,
                                      icon: "heart.text.square",
                                      text: "좋아요 한 게시글 공개")
                        .onChange(of: openHighlight) { _, newValue in
                            if newValue {
                                viewModel.currentUser?.openHighlight = "yes"
                                Firestore.firestore().collection("users").document(userNameID).updateData(["openHighlight": "yes"])
                            } else {
                                viewModel.currentUser?.openHighlight = "no"
                                Firestore.firestore().collection("users").document(userNameID).updateData(["openHighlight": "no"])
                            }
                            
                        }
                    
                    
                    Button {
                        showingCashModal.toggle()
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "trash",
                                              text: "캐시 지우기")
                        }
                    }
                    
                    Button {
                        showingDeleteModal.toggle()
                    } label: {
                        VStack {
                            SettingRedCell(icon: "multiply.square", 
                                           text: "계정 탈퇴")
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showingCashModal, content: {
            ModalAlertView(showingCircleImage: false,
                           mainTitle: .cash,
                           subTitle: .cash,
                           removeMessage: .cash)
                .background(Color.clear)
                .presentationDetents([.fraction(0.4)])
        })
        
        .sheet(isPresented: $showingDeleteModal, content: {
            ModalAlertView(showingCircleImage: true,
                           mainTitle: .account,
                           subTitle: .account, 
                           removeMessage: .account)
                .background(Color.clear)
                .presentationDetents([.fraction(0.4)])
        })
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("다른 설정들")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .font(.system(.subheadline))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(.body))
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
}
