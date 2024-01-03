//
//  NotificationsView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct NotificationsView: View {
    
    @State var mentions = false
    @State var comments = false
    @State var friendsRequests = false
    @State var lateBeReal = false
    @State var realMojis = false
    
    @State var buttonActive = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("알림")
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                
                VStack {
                    VStack {
                        HStack {
                            Text("PADO에서는 푸시 알림을 제어할 수 있습니다.")
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("수신할 알림 유형을 선택할 수 있습니다.")
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                    }
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                    
                    VStack(spacing: 14) {
                        VStack {
                            NotificationsButtonView(icon: "person.crop.square.filled.and.at.rectangle", text: "말하기와 태그", toggle: $mentions)
                            
                            HStack {
                                Text("hthankyi님이 kmh5038님의 PADO에서 회원님을 언급했어요.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsButtonView(icon: "bubble.left.fill", text: "댓글들", toggle: $comments)
                            
                            HStack {
                                Text("hthankyi님이 회원님의 PADO에 댓글을 달았어요.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsButtonView(icon: "person.2.fill", text: "친구 요청", toggle: $friendsRequests)
                            
                            HStack {
                                Text("donghochoi님이 친구 요청을 보냈어요.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsButtonView(icon: "timer", text: "늦은 PADO.", toggle: $lateBeReal)
                            
                            HStack {
                                Text("hthankyi님이 방금 늦은 PADO을 게시했습니다.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsButtonView(icon: "face.smiling", text: "RealMojis.", toggle: $realMojis)
                            
                            HStack {
                                Text("kmh5038님이 회원님의 PADO에 반응했습니다.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    WhiteButtonView(buttonActive: $buttonActive, text: "저장")
                        .onChange(of: mentions || comments || friendsRequests || lateBeReal || realMojis) { oldValue, newValue in
                            self.buttonActive = true
                        }
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
