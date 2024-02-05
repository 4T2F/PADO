//
//  SettingAskView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import MessageUI
import SwiftUI

struct SettingAskView: View {
    
    @State private var showingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var mailSentSuccessfully = false
    @State private var showAlert = false
    @State private var title = "PADO 문의하기"
    @State private var messageBody = "자세한 문의 내용을 적어주세요"
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Text("문의하기")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("dismissArrow")
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
            
            Image(systemName: "envelope")
                .resizable()
                .fontWeight(.regular)
                .frame(width: 80, height: 60)
                .foregroundStyle(Color(.systemBlue))
                .padding(.bottom, 40)
            
            Text("확인을 누르면 메일로 이동합니다")
                .font(.system(size: 22))
                .fontWeight(.medium)
                .padding(.bottom, 70)
            
            HStack {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 8)
                
                Text("PADO를 사용할때 사소한 부분이라도 불편한 부분을 알려주세요.")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.trailing)
            }
            .padding(.bottom, 40)

            HStack {
                Image(systemName: "note.text.badge.plus")
                    .resizable()
                    .frame(width: 35, height: 30)
                    .padding(.horizontal, 5)
                
                Text("PADO에 추가되기를 원하는 기능을 알려주세요.")
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button {
                if MFMailComposeViewController.canSendMail() {
                    self.showingMailView = true
                } else {
                    self.showAlert = true
                    print("메일을 보내지 못했습니다.")
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                        .foregroundStyle(.blueButton)
                    
                    Text("확인")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
            }
            .sheet(isPresented: $showingMailView) {
                MailView(isShowing: $showingMailView, result: $mailResult, title: $title, messageBody: $messageBody)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("메일 설정 오류"),
                    message: Text("메일을 보낼 수 없습니다. 기기의 메일 설정을 확인해주세요."),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
