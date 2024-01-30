//
//  SettingAskView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import Photos
import PhotosUI
import SwiftUI

struct SettingAskView: View {
    @State var inquiry: String = ""
    @State var fileNum: Int = 0
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    @State var askSeletedImage1: Image = Image("")
    @State var askSeletedImage2: Image = Image("")
    @State var askSeletedImage3: Image = Image("")
    @State var isShowingAskImage1: Bool = false
    @State var isShowingAskImage2: Bool = false
    @State var isShowingAskImage3: Bool = false
    
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: SurfingViewModel
    
    let placeholder: String = "저희 PADO를 이용하시는 동안 불편한 점이나 문의사항이 있으시다면 의견을 보내주세요."
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // MARK: - 문의하기뷰, 탑셀
                VStack {
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
                                    .foregroundStyle(.grayButton)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                VStack {
                    // MARK: - 문의하기뷰, 콘텐츠(글)
                    ZStack {
                        TextEditor(text: $inquiry)
                            .foregroundStyle(Color.white)
                            .opacity(0.3)
                            .frame(width: width * 0.9, height: 150)
                            .scrollContentBackground(.hidden)
                            .background(.mainBackground)
                            .modifier(RoundedEdge(width: 1,
                                                  color: Color(UIColor.systemGray3),
                                                  cornerRadius: 10)
                            )
                            .padding(.bottom)
                        
                        if inquiry.isEmpty {
                            Text(placeholder)
                                .font(.system(size: 14))
                                .frame(height: 50)
                                .lineSpacing(10)
                                .foregroundStyle(Color.white.opacity(0.25))
                                .padding(.horizontal, 40)
                        }
                    }
                    // MARK: - 문의하기뷰, 콘텐츠(사진)
                    ZStack {
                        Rectangle()
                            .frame(width: width * 0.9, height: 120)
                            .foregroundStyle(Color("mainBackgroundColor"))
                            .modifier(RoundedEdge(width: 1,
                                                  color: Color(UIColor.systemGray3),
                                                  cornerRadius: 10))
                        VStack {
                            HStack {
                                Text("파일첨부\(fileNum)/3")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.white)
                                    .opacity(0.3)
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                if isShowingAskImage1 {
                                    askSeletedImage1
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .onAppear {
                                            fileNum += 1
                                        }
                                } else {
                                    SettingAskButton(askSeletedImage: $askSeletedImage1, isShowingAskImage: $isShowingAskImage1)
                                }
                                
                                if isShowingAskImage2 {
                                    askSeletedImage2
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .onAppear {
                                            fileNum += 1
                                        }
                                } else {
                                    SettingAskButton(askSeletedImage: $askSeletedImage2, isShowingAskImage: $isShowingAskImage2)
                                }
                                
                                if isShowingAskImage3 {
                                    askSeletedImage3
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .onAppear {
                                            fileNum += 1
                                        }
                                } else {
                                    SettingAskButton(askSeletedImage: $askSeletedImage3, isShowingAskImage: $isShowingAskImage3)
                                }
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                    
                    VStack {
                        if !inquiry.isEmpty {
                            Button {
                                // TODO: - 보내기 버튼 구현
                                dismiss()
                            } label: {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: width * 0.9, height: 46)
                                        .foregroundStyle(Color("blueButtonColor"))
                                    
                                    HStack {
                                        Text("보내기")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        } else {
                            Button {
                                // TODO: - 보내기 버튼 구현
                            } label: {
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: width * 0.9, height: 46)
                                        .foregroundStyle(Color("grayButtonColor"))
                                    
                                    HStack {
                                        Text("보내기")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
        .padding(.top, 10)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingAskView()
}
