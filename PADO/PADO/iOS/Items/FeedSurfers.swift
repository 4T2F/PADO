//
//  FeedSurfers.swift
//  PADO
//
//  Created by 최동호 on 1/16/24.
//

import SwiftUI

struct FeedSurfers: View {
    var body: some View {
        HStack {
            ZStack {
                Image("pp2")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .offset(x: 15, y: 0) // 오른쪽으로 10 포인트 이동
                Image("pp")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .offset(x: -15, y: 0) // 왼쪽으로 10 포인트 이동
            }
            .padding(.leading, 8)
            .padding(.trailing, 20)
            
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        // 유저 프로필
                    } label: {
                        Text("Hsungjin")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                    }

                   
                    Text("x")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                    Button {
                        // 유저 프로필
                    } label: {
                        Text("DogStar")      
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                    }
                }
                
                Text("어제 오후 11:44:23") // • option + num8
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal)
    }
}

