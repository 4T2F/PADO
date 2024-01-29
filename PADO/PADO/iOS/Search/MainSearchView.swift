//
//  MainSearchView.swift
//  PADO
//
//  Created by 황성진 on 1/18/24.
//

import SwiftUI

struct MainSearchView: View {
    // MARK: - PROPERTY
    
    @State var mainSearch: String = ""
    @ObservedObject var viewModel = SurfingViewModel()
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return mainSearch
        } set: {
            mainSearch = $0
            viewModel.updateSearchText(with: $0)
        }
        
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading) {
                ZStack {
                    
                    HStack {
                        Text("PADO")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
                
                SearchBar(text: searchTextBinding,
                          isLoading: $viewModel.isLoading)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("최근검색")
                    .font(.system(size: 14, weight: .semibold))
                    .padding()
                
                ScrollView {
                    ForEach(1...10, id: \.self) {_ in
                        FriendCellView(searchRightSymbol: .xmark)
                    }
                    HStack {
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("모두 삭제")
                                .foregroundStyle(.grayButton)
                                .font(.system(size: 14))
                        }
                    }
                    .padding()
                }
            } //: VSTACK
        } //: ZSTACK
    }
}

#Preview {
    MainSearchView()
}
