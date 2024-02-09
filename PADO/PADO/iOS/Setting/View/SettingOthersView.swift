//
//  SettingOthers.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingOthersView: View {
    @State private var showingCashModal: Bool = false
    @State private var showingDeleteModal: Bool = false
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
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
            ModalAlertView(showingCircleImage: false, mainTitle: .account, subTitle: .account, removeMessage: .account)
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


#Preview {
    SettingOthersView()
}
