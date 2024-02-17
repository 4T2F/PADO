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
                        WebView(url: "https://notch-galaxy-ab8.notion.site/de9e469fca24427cbcf16ada473c9231?pvs=4")
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
                        WebView(url: "https://notch-galaxy-ab8.notion.site/1069395170324617b046f096118cd815")
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

