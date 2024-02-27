//
//  SettingInfoView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
import SwiftUI

struct SettingInfoView: View {
    @Environment (\.dismiss) var dismiss
    @State var showWK = false
    @State var showPersonalInfoWK = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Button {
                        // TODO: - 이용약관 링크 걸기
                        showWK.toggle()
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "doc.text", text: "이용약관")
                        }
                    }
                    .sheet(isPresented: $showWK) {
                        WebView(url: "https://notch-galaxy-ab8.notion.site/6ff60c61aa104cd6b1471d3ea5102ce3?pvs=4")
                    }
                    
                    Button {
                        // TODO: - 개인정보처리방침 링크 걸기
                        showPersonalInfoWK.toggle()
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "doc.text", text: "개인정보처리방침")
                        }
                    }
                    .sheet(isPresented: $showPersonalInfoWK) {
                        WebView(url: "https://notch-galaxy-ab8.notion.site/3147fcead0ed41cdad6e2078893807b7?pvs=4")
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("정보")
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

