//
//  SettingView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
import SwiftUI

struct SettingView: View {
    @State var width = UIScreen.main.bounds.width
    @State private var showingSignOutModal: Bool = false
    @Environment (\.dismiss) var dismiss
    @StateObject var surfingVM = SurfingViewModel()
    @StateObject var profileVM = ProfileViewModel()
    
    var name: String = "PADO"
    var nickName: String = "pado"
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("설정")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.leading)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: SettingNotificationView()) {
                        SettingViewCell(settingTittle: "알림")
                    }
                    
                    SettingDivider()
                    
                    NavigationLink(destination: SettingOthersView()) {
                        SettingViewCell(settingTittle: "다른 설정들")
                    }
                    
                    SettingDivider()
                    
                    NavigationLink(destination: SettingBlockUser(profileVM: profileVM)) {
                        SettingViewCell(settingTittle: "차단 목록")
                    }
                   
                    SettingDivider()
                        .padding(.bottom, 30)
                    
                    Text("정보")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.leading)
                        .padding(.bottom, 20)
                    
                    SettingViewCell(settingTittle: "PADO 평가하기")
                    
                    SettingDivider()
                    
                    NavigationLink(destination: SettingAskView().environmentObject(surfingVM)) {
                        SettingViewCell(settingTittle: "문의하기")
                    }
                    
                    SettingDivider()
                    
                    NavigationLink(destination: SettingInfoView()) {
                        SettingViewCell(settingTittle: "정보")
                    }
                    
                    SettingDivider()
                    
                    Button {
                        showingSignOutModal.toggle()
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.red)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, -7)
                    }
                    .sheet(isPresented: $showingSignOutModal, content: {
                        ModalAlertView(showingCircleImage: true, mainTitle: .signOut, subTitle: .signOut, removeMessage: .signOut)
                            .background(Color.clear)
                            .presentationDetents([.fraction(0.4)])
                    })
                    
                    SettingDivider()
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("2024, PADO all rights reserved.")
                        Text("Powered by 4T2F")
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 10))
                    .padding(.bottom)
                }
                .padding(.top, 10)
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationBarBackButtonHidden()
            .navigationTitle("설정 및 개인정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("취소")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                }
            }
            .toolbarBackground(Color(.main), for: .navigationBar)
        }
    }
}



