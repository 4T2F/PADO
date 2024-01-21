//
//  NotificationView.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct NotificationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        ScrollView {
                            // 나중에 ForEach로 만들어야함(?)
                            VStack(spacing: 25) {
                                
                                FollowerCell(name: "official_tuna")
                                
                                CreateFeedCell(name: "donghochoi")
                                
                                SurferCell(name: "Hsungjin", day: 3)
                                
                                FollowerCell(name: "official_tuna")
                                
                                FollowerCell(name: "official_tuna")
                                
                                FollowerCell(name: "official_tuna")
                            }
                            .padding(.top, 50)
                        }
                        VStack {
                            ZStack {
                                Text("알림")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Image("dismissArrow")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 20))
                                    }
                                    
                                    Spacer()
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
}

#Preview {
    NotificationView()
}
