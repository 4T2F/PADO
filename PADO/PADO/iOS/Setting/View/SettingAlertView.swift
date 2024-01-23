//
//  SettingAlertView.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
// 파기할 파일
import SwiftUI

struct SettingAlertView: View {
    @Environment (\.dismiss) var dismiss
    @Binding var isPresentPopup: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                
                VStack {
                    Text("캐시지우기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.bottom)
                    
                    Text("캐시를 지우면 몇몇의 문제가 해결될 수 있어요")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.bottom)
                }
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .padding(.top)
                
                Divider()
                
                Button {
                    isPresentPopup.toggle()
                } label: {
                    Text("PADO 캐시지우기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.red)
                        
                }
                .padding(.vertical, 15)
                
            }
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 20))
            .padding(.bottom, 5)
            
            Button {
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: UIScreen.main.bounds.width * 1, height: 70)
                    
                    Text("취소")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.black)
                }
            }
            .foregroundStyle(.white)

            
        }
    }
}

#Preview {
    SettingAlertView(isPresentPopup: .constant(true))
}

