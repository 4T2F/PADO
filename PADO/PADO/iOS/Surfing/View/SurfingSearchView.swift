//
//  SurfingSearchView.swift
//  PADO
//
//  Created by 황성진 on 1/17/24.
//

import SwiftUI

struct SurfingSearchView: View {
    
    @State var surfingSearch: String = ""
    @ObservedObject var viewModel = SurfingViewModel()
    
    var body: some View {
        
        let searchTextBinding = Binding {
            return surfingSearch
        } set: {
            surfingSearch = $0
            viewModel.updateSearchText(with: $0)
        }
        ZStack {
            Color.main.ignoresSafeArea()
            VStack(alignment: .leading) {
                ZStack {
                    
                    HStack {
                        Text("PADO")
                            .font(.system(.title2))
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                SearchBar(text: searchTextBinding,
                          isLoading: $viewModel.isLoading)
                .padding()
                
                Spacer()
                
                Text("최근검색")
                    .font(.system(.subheadline, weight: .semibold))
                    .padding()
                
//                ScrollView {
//                    ForEach(1...10, id: \.self) {_ in
//                        SearchCellView(searchRightSymbol: .chevron)
//                    }
//                    HStack {
//                        Spacer()
//                        
//                        Button {
//                            
//                        } label: {
//                            Text("모두 삭제")
//                                .foregroundStyle(.grayButton)
//                                .font(.system(.subheadline))
//                        }
//                    }
//                    .padding()
//                }
            } //: VSTACK
        } //: ZSTACK
    }
}
