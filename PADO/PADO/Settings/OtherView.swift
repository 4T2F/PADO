//
//  OtherView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct OtherView: View {
    
    @State var fastCamera = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("다른 설정들")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                VStack {
                    VStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                                
                                Text("고속 카메라 (품질 저하)")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 14))
                                
                                Toggle("", isOn: $fastCamera)
                            }
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
                            .frame(height: 30)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Image(systemName: "xmark.app")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                                
                                Text("캐시 지우기")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 14))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
                            .frame(height: 30)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 45)
                                .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            
                            HStack {
                                Spacer()
                                
                                Text("계정 삭제")
                                    .foregroundStyle(.red)
                                
                                Spacer()
                            }
                            .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
                            .frame(height: 30)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    OtherView()
}
