//
//  RequestsView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct RequestsView: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 65)
                        .foregroundStyle(Color(red: 40/255, green: 40/255, blue: 35/255))
                        .overlay {
                            HStack {
                                Image("pp")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                                
                                VStack(alignment: .leading) {
                                    Text("PADO 초대")
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                    
                                    Text("pa.do/kangciu")
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("친구 요청 (0)")
                                .foregroundStyle(Color(red: 205/255, green: 204/255, blue: 209/255))
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                            
                            Spacer()
                            
                            HStack {
                                Text("보냄")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                        .padding(.horizontal, 14)
                        
                        RoundedRectangle(cornerRadius: 18)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 90)
                            .foregroundStyle(Color(red: 28/255, green: 28/255, blue: 30/255))
                            .overlay {
                                VStack(spacing: 8) {
                                    HStack {
                                        Spacer()
                                        
                                        Text("보류 중인 요청 없음")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("보류 중인 요청이 없습니다.")
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                    }
                                }
                            }
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding(.top, 110)
        }
    }
}

#Preview {
    RequestsView()
}
