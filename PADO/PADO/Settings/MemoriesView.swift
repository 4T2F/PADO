//
//  MemoriesView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct MemoriesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ZStack {
                    ScrollView {
                        VStack {
                            VStack {
                                HStack {
                                    Text("추억 기능이 켜져 있습니다.")
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 20))
                                    
                                    Spacer()
                                }
                                
                                Text("회원님의 모든 PADO들이 자동으로 회원님의 추억에 추가되며, 이 PADO들은 회원님에게만 보입니다.")
                                    .foregroundStyle(.white)
                                    .padding(.top, -2)
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(height: 210)
                                    .foregroundStyle(Color(red: 22/255, green: 4/255, blue: 3/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.red, lineWidth: 1)
                                    }
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("추억 기능 비활성화 및 삭제")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Text("추억 기능을 비활성화하면, 저장되어 있던 모든 PADO들이 영구적으로 삭제되며 복구가 불가능합니다.")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                            
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Text("앞으로 공유하시는 PADO들도 추억에 저장되지 않으며 시간이 지난 후 삭제되게 됩니다.")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                            
                                            Spacer()
                                        }
                                    }
                                    .padding(.top, -6)
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(width: UIScreen.main.bounds.width * 0.35, height: 38)
                                        .foregroundStyle(Color(red: 44/255, green: 44/255, blue: 46/255))
                                        .overlay {
                                            Text("추억 기능 끄기")
                                                .foregroundStyle(.red)
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.top, 8)
                                }
                                .padding(.leading)
                            }
                            .padding(.top, 22)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 50)
                    }
                    
                    VStack {
                        ZStack {
                            Text("추억")
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
                                
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16))
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    MemoriesView()
}
