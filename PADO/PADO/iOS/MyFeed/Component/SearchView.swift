//
//  SearchView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct SearchView: View {
    // MARK: - PROPERTY
    @Binding var searchText: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("검색", text: $searchText)
                    .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            } //: HSTACK
            .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
            .background(Color("grayButtonColor"))
            .cornerRadius(10.0)
            
        } //: HSTACK
    }
}

//#Preview {
//    SearchView()
//}
