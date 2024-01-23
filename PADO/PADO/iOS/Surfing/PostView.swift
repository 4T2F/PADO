//
//  PostView.swift
//  PADO
//
//  Created by 김명현 on 1/23/24.
//

import SwiftUI

struct PostView: View {
    
    @State private var postingTitle = ""
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
            VStack {
                ZStack {
                    Text("PADO")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .foregroundStyle(.white)
                                .font(.system(size: 22))
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                
            } //: VSTACK
            
            VStack {
                
                Image("pp")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.5)
                    .padding(.vertical, 20)
                        
                Spacer()
                
                HStack {
                    
                    Text("제목")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                    
                    Spacer()
                } //: HSTACK
                
                .padding(.leading, 20)
                
                TextField("제목을 입력해주세요", text: $postingTitle)
                    .padding(.leading, 20)
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(UIColor.systemGray))
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 0.5)
                
                HStack {
                    Text("서핑리스트")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    Button {
                        //
                    } label: {
                        
                        Text("+")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                        
                    }
                    .padding(.trailing)
                } //: HSTACK
                .padding(20)
                
                Spacer()
                
                Button {
                    // 게시요청 로직
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                            .foregroundStyle(.blueButton)
                        
                        Text("게시요청")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                }
                
                
            } //: VSTACK
         //: ZSTACK
    }
}

#Preview {
    PostView()
}



