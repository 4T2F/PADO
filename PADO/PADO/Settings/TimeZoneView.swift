//
//  TimeZoneView.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct TimeZoneView: View {
    
    @State var area = "westasia"
    
    @Environment(\.dismiss) var dismiss
    
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("시간대")
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
                    VStack {
                        HStack {
                            Text("시간대 선택")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("낮 동안에 PADO 알림을 받으려면 시간대를 선택하세요. 시간대를 변경하시면, 현재의 모든 PADO가 삭제됩니다. 시간대는 하루 한번만 변경할 수 있어요.")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                            
                            Spacer()
                        }
                        .padding(.top, -8)
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .frame(width: width * 0.9, height: 195)
                                .foregroundStyle(.white)
                                .opacity(0.07)
                            
                            VStack {
                                Button {
                                    self.area = "americas"
                                } label: {
                                    HStack {
                                        Image(systemName: "globe.americas.fill")
                                            .foregroundStyle(.white)
                                        
                                        Text("북/남미")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        if area == "americas" {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.03)
                                    .frame(height: 30)
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    Rectangle()
                                        .frame(width: width * 0.8, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                }
                                
                                Button {
                                    self.area = "europe"
                                } label: {
                                    HStack {
                                        Image(systemName: "globe.europe.africa.fill")
                                            .foregroundStyle(.white)
                                        
                                        Text("유럽")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        if area == "europe" {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.03)
                                    .frame(height: 30)
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    Rectangle()
                                        .frame(width: width * 0.8, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                }
                                
                                Button {
                                    self.area = "eastasia"
                                } label: {
                                    HStack {
                                        Image(systemName: "globe.asia.australia.fill")
                                            .foregroundStyle(.white)
                                        
                                        Text("서아시아")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        if area == "eastasia" {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.03)
                                    .frame(height: 30)
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    Rectangle()
                                        .frame(width: width * 0.8, height: 0.3)
                                        .opacity(0.4)
                                        .foregroundStyle(.gray)
                                }
                                
                                Button {
                                    self.area = "westasia"
                                } label: {
                                    HStack {
                                        Image(systemName: "globe.asia.australia.fill")
                                            .foregroundStyle(.white)
                                        
                                        Text("동아시아")
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        if area == "westasia" {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .padding(.horizontal, width * 0.03)
                                    .frame(height: 30)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 14)
                            .frame(width: width * 0.9, height: 45)
                            .foregroundStyle(Color(red: 86/255, green: 86/255, blue: 88/255))
                            .overlay {
                                Text("저장")
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 14))
                            }
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    TimeZoneView()
}
