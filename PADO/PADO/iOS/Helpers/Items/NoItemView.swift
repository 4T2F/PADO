//
//  NoItemView.swift
//  PADO
//
//  Created by 황성진 on 2/17/24.
//

import SwiftUI

struct NoItemView: View {
    var itemName: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(itemName)
                .foregroundColor(Color(.systemGray))
                .font(.system(.body))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}
