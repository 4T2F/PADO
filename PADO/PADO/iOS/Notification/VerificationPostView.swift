//
//  VerificationPostView.swift
//  PADO
//
//  Created by 황민채 on 1/17/24.
//

// 레거시~
import SwiftUI

struct VerificationPostView: View {
    
    var name: String = "천랑성"
    @State private var postTitle: String = "제목입니다"
    @State var width = UIScreen.main.bounds.width
    @State private var buttonActive: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    // MARK: - 서핑뷰, 탑셀
                    VStack(alignment: .leading) {
                        ZStack {
                            HStack {
                                
                                Button {
                                    
                                } label: {
                                    Image("dismissArrow")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20))
                                }
                                
                                Spacer()
                                
                            }
                            .padding(.vertical, 5)
                            
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 22)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                    }
                    
                    VStack{
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Image("pp")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 500)
                            
                            Text(postTitle)
                                .padding(.horizontal)
                                .font(.system(size: 20, weight: .semibold))
                            Text("\(name)님, 게시를 수락해주세요.")
                                .padding(.horizontal)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button {
                                // TODO:
                            } label: {
                                GrayButtonView(text: "거절하기", grayButtonX: 0.3)
                            }
                            
                            Button {
                                
                            } label: {
                                PostButtonView(postX: 0.55)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VerificationPostView()
}
