//
//  SelectUserView.swift
//  PADO
//
//  Created by 강치우 on 2/22/24.
//

import SwiftUI

struct SelectUserView: View {
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundStyle(Color(.systemGray4))
                        .padding(.bottom, 4)
                    
                    // 닉네임 있으면 둘다, 닉네임 없으면 userID만 넣는 조건문 필요
                    VStack(alignment: .leading, spacing: 0) {
                        Text("하나비")
                            .font(.system(size: 14, weight: .semibold))
                        Text("hanabi")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                .padding([.bottom, .horizontal], 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(1...30, id: \.self) { post in
                                ZStack(alignment: .bottomLeading) {
                                    Button {
                                        // 사진 선택하면 바로 PadoRideEditView로 넘어가게 해야함
                                    } label: {
                                        Image("Pic2")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                                            .clipped()
                                    }
                                }
                                .frame(width: (UIScreen.main.bounds.width / 3) - 2, height: 160)
                            }
                        }
                    }
                }
            }
            .padding(.top)
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .navigationBarBackButtonHidden()
        .navigationTitle("파도타기")
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
                    .foregroundStyle(.white)
                }
            }
        }
        .toolbarBackground(Color(.main), for: .navigationBar)
    }
}

#Preview {
    SelectUserView()
}
