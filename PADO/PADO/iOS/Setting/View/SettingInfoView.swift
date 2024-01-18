//
//  SettingInfoView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
import SwiftUI

struct SettingInfoView: View {
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("정보")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                
                VStack {
                    Button {
                        //TODO: - 이용약관 링크 걸기
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "doc.text", text: "캐시 지우기")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    Button {
                        //TODO: - 개인정보처리방침 링크 걸기
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "doc.text", text: "개인정보처리방침")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    Button {
                        //TODO: - 개발자에게 플러팅하기 로직 구현 필요
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "heart.fill", text: "개발자에게 플러팅하기")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingInfoView()
}
