//
//  SettingNotificationView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingNotificationView: View {
    
    @State var noti = false
    
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("알림")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                // TODO: - 뒤로가기 버튼 구현
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
                        SettingToggleCell(icon: "square.and.pencil", text: "알림 설정", toggle: $noti)
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }
    }
}


#Preview {
    SettingNotificationView()
}
