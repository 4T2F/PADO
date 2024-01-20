//
//  SettingNotificationView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//

import SwiftUI

struct SettingNotificationView: View {
    
    @Environment (\.dismiss) var dismiss
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
                                dismiss()
                            } label: {
                                Image("dismissArrow")
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
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SettingNotificationView()
}
