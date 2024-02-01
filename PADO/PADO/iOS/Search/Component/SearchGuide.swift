//
//  SearchGuide.swift
//  PADO
//
//  Created by 최동호 on 2/1/24.
//

import SwiftUI

struct SearchGuide: View {
    var body: some View {
        VStack{
            Text(Image(systemName: "magnifyingglass"))
                .font(.system(size: 40))
                .foregroundColor(Color.gray)
                .padding(.bottom, 3)
            Text("검색 내역이 없어요")
                .foregroundColor(Color.gray)
                .font(.system(size: 15))
                .bold()
            
        }
    }
}
