//
//  SurfingMakeView.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

import SwiftUI

struct SurfingMakeView: View {
    
    @State var name: String = "천랑성"
    @State var postTitle: String = ""
    @State var width = UIScreen.main.bounds.width
    @State var buttonActive: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color("mainBackgroundColor").ignoresSafeArea()
                    
                    // MARK: - 서핑뷰, 탑셀
                    VStack {
                        ZStack {
                            Text("\(name)님을 서핑중")
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                            
                            HStack {
                                Button {
                                    
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
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image("noPhoto")
                        }
                        .padding(.bottom, 15)
                        Text("사진을 선택해주세요")
                        
                        Spacer()
                        VStack {
                            Divider()
                            
                            
                            TextField("제목을 입력하세요", text: $postTitle)
                                .foregroundStyle(Color.white)
                                .padding(.horizontal)
                                
                        }
                        .offset(y: -100)
                        
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                                    .foregroundStyle(Color("blueButtonColor"))
                                HStack {
                                    
                                    Text("게시요청")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
                                .frame(height: 30)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SurfingMakeView()
}
