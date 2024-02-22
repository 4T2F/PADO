//
//  SettingOthers.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct SettingOthersView: View {
    @State private var showingCashModal: Bool = false
    @State private var showingDeleteModal: Bool = false
    @State var savePhoto: Bool = UserDefaults.standard.bool(forKey: "savePhoto")

    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment (\.dismiss) var dismiss
    
    @Binding var openHighlight: Bool
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    SettingToggleCell(icon: "photo.badge.plus", text: "파도타기 갤러리 저장", toggle: $savePhoto)
                        .onChange(of: savePhoto) { _, newValue in
                            UserDefaults.standard.set(newValue, forKey: "savePhoto")
                        }
                    
                    SettingToggleCell(icon: "heart.text.square", text: "하이라이트 공개 여부", toggle: $openHighlight)
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
                            SettingNormalCell(icon: "trash", text: "캐시 지우기")
                        }
                    }
                    
                    Button {
                        showingDeleteModal.toggle()
                    } label: {
                        VStack {
                            SettingRedCell(icon: "multiply.square", text: "계정 탈퇴")
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .sheet(isPresented: $showingCashModal, content: {
            ModalAlertView(showingCircleImage: false, mainTitle: .cash, subTitle: .cash, removeMessage: .cash)
                .background(Color.clear)
                .presentationDetents([.fraction(0.4)])
        })
        
        .sheet(isPresented: $showingDeleteModal, content: {
            ModalAlertView(showingCircleImage: true, mainTitle: .account, subTitle: .account, removeMessage: .account)
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
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Text("뒤로")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
}
