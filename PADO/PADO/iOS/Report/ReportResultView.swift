//
//  ReportResultView.swift
//  PADO
//
//  Created by 김명현 on 1/16/24.
//

import MessageUI
import SwiftUI

struct ReportResultView: View {
    @Binding var isShowingReportView: Bool
    
    @State private var showingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var mailSentSuccessfully = false
    @State private var showAlert = false
    @State private var title = "PADO 신고 문의"
    @State private var messageBody = "자세한 신고 내용을 적어주세요"
    
    var body: some View {
        VStack {
            Image(systemName: "megaphone")
                .resizable()
                .fontWeight(.regular)
                .frame(width: 35, height: 35)
                .foregroundStyle(Color(.systemBlue))
                .padding(.bottom, 20)
            
            
            Text("확인을 누르면 메일로 이동합니다")
                .font(.system(size: 22))
                .fontWeight(.medium)
                .padding(.bottom, 20)
            
            Text("신고 용도 :")
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                    
                    Text("사람들이 PADO에서 다양한 유형의 콘텐츠로 인해 겪고 있는 문제를 이해합니다.")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .padding(.trailing, 15)
                        .lineSpacing(5)
                } //: HStack
                .padding(.bottom, 30)
                
                HStack {
                    Image(systemName: "eye.slash")
                        .resizable()
                        .frame(width: 25, height: 20)
                        .bold()
                        .padding(.horizontal)
                    Text("앞으로 이 유형의 콘텐츠를 더 적게 표시합니다.")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                } //: HStack
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
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 45)
                        .foregroundStyle(.blue)
                    
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
        } //: VStack
        .frame(width: UIScreen.main.bounds.width)
        .padding(.vertical)
        .padding(.top)
        .navigationBarBackButtonHidden()
        .background(.main, ignoresSafeAreaEdges: .all)
    }
    
    func handleMailResult() {
        // 메일 결과를 처리하고 mailSentSuccessfully 상태를 업데이트합니다.
        if case .success(let result) = mailResult, result == .sent {
            mailSentSuccessfully = true
        }
    }
}

#Preview {
    ReportResultView(isShowingReportView: .constant(false))
}
