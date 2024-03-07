//
//  CustomTF.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct CustomTF: View {
    @Binding var value: String
    
    var hint: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8, content: {
            VStack(alignment: .leading, spacing: 8, content: {
                TextField(hint, text: $value)
                    .multilineTextAlignment(.leading)
                
                Divider()
            })
        })
    }
}
