//
//  AdvancedSettingsCell.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct AdvancedSettingsCell: View {
    
    var mainTitle = ""
    var title = ""
    var subtitle = ""
    
    @State var toggleOnOff: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(mainTitle)
                .font(.system(size: 16))
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Toggle(isOn: $toggleOnOff) {
                    // func
                }
                .frame(width: 50, height: 35)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AdvancedSettingsCell(mainTitle: "좋아요 및 조회수", title: "이 게시물의 좋아요 수 숨기기", subtitle: "이 게시물의 총 좋아요 수는 회원님만 볼 수 있어요", toggleOnOff: false)
}
