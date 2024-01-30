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
                SearchBar(text: searchTextBinding,
                          isLoading: $viewModel.isLoading)
                    .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Text("최근검색")
                        .font(.system(size: 14, weight: .semibold))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("기록 삭제")
                            .foregroundStyle(Color(.systemGray))
                            .font(.system(size: 14))
                    }
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    ForEach(1...10, id: \.self) {_ in
                        FriendCellView(searchRightSymbol: .xmark)
                            .padding(.vertical, 3)
                    }
                }
            }
            .padding(.top, 15)
        }
    }
}

#Preview {
    MainSearchView()
}
