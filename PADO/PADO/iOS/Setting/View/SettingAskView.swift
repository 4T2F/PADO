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
    @State private var buttonActive: Bool = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var mailSentSuccessfully = false
    @State private var showAlert = false
    @State private var title = "PADO 문의하기"
    @State private var messageBody = "자세한 문의 내용을 적어주세요"
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    Image(systemName: "envelope")
                        .font(.system(size: 50))
                        .foregroundStyle(Color(.systemBlue))
                        .padding(.bottom, 40)
                    
                    Text("확인을 누르면 메일로 이동합니다")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.bottom, 50)
                    
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.trailing, 8)
                        
                        Text("PADO를 사용할때 사소한 부분이라도 불편한 부분을 알려주세요.")
                            .font(.system(size: 16))
                            .padding(.trailing)
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "note.text.badge.plus")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .padding(.horizontal, 5)
                        
                        Text("PADO에 추가되기를 원하는 기능을 알려주세요.")
                            .font(.system(size: 16))
                            .lineLimit(2)
                    }
                    .padding(.trailing, 7)
                    
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
                                .foregroundStyle(.blue)
                            
                            Text("확인")
                                .foregroundStyle(.white)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.bottom, 20)
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
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("문의하기")
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
