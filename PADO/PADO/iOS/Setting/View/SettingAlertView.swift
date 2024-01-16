//
//  SettingAlertView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
// 파기할 파일
import SwiftUI

struct SettingAlertView: View {
    @Binding var isPresentPopup: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("캐시지우기")
                
                Text("캐시를 지우면 몇몇의 문제가 해결될 수 있어요")
            }
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .padding(30)
            
            Divider()
            
            Button {
                isPresentPopup.toggle()
            } label: {
                Text("PADO 캐시지우기")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.red)
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 10)
            
        }
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 5))
    }
}

#Preview {
    SettingAlertView(isPresentPopup: .constant(true))
}

