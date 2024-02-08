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
