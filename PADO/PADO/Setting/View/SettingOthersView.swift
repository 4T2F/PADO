//
//  SettingOthers.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
import SwiftUI

struct SettingOthersView: View {
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("다른설정들")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                // TODO: - 뒤로가기 버튼 구현
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
                        //TODO: - 캐시지우기 로직 구현
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "trash", text: "캐시 지우기")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    Button {
                        //TODO: - 계정삭제 로직 구현
                    } label: {
                        VStack {
                            SettingRedCell(icon: "multiply.square", text: "계정 삭제")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    SettingOthersView()
}
