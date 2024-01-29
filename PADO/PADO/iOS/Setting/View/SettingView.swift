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
//    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var viewModel = SurfingViewModel()
    
    @Binding var isShowingSetting: Bool
    
    
    var name: String = "PADO"
    var nickName: String = "pado"
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Button {
                        dismiss()
                        isShowingSetting = false
                    } label: {
                        Image("dismissArrow")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                    }
                    
                    Spacer()
                    
                    Text("설정")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.trailing, 20)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                Text("설정")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.leading)
                    .padding(.bottom, 30)
                
                NavigationLink(destination: SettingNotificationView()) {
                    SettingViewCell(settingTittle: "알림")
                }
 
                SettingDivider()
                
                NavigationLink(destination: SettingOthersView()) {
                    SettingViewCell(settingTittle: "다른 설정들")
                }
                
                SettingDivider()
                    .padding(.bottom, 30)
                    
                Text("정보")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.leading)
                    .padding(.bottom, 30)
                
                SettingViewCell(settingTittle: "PADO 평가하기")
                
                SettingDivider()
                
                NavigationLink(destination: SettingAskView().environmentObject(viewModel))  {
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
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.red)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                            .bold()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -7)
                }
                .sheet(isPresented: $showingSignOutModal, content: {
                    ModalAlertView(showingCircleImage: false, mainTitle: .signOut, subTitle: .signOut, removeMessage: .signOut)
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
                .font(.system(size: 11))
                .padding(.bottom)
            }
                       
        }
        .navigationBarBackButtonHidden(true)
    }
}



