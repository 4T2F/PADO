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
        VStack{
            Text(itemName)
                .foregroundColor(Color.gray)
                .font(.system(size: 16))
                .fontWeight(.semibold)
        }
    }
}
