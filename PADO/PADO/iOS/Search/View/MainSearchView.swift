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
    @ObservedObject var searchVM: SearchViewModel
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return mainSearch
        } set: {
            mainSearch = $0
            searchVM.updateSearchText(with: $0)
        }
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                SearchBar(text: searchTextBinding,
                          isLoading: $searchVM.isLoading)
                .padding(.horizontal)
                if mainSearch.isEmpty {
                    SearchGuide()
                        .padding(.top, 150)
                    
                } else if searchVM.viewState == .empty {
                    Text("검색 결과가 없어요")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .bold()
                        .padding(.top, 150)
                    
                }  else if searchVM.viewState == .ready {
                    ScrollView(showsIndicators: false) {
                        ForEach(searchVM.searchResults) { result in
                            SearchCellView(user: result)
                                .padding(.vertical, 3)
                        }
                    }
                    .padding(.top, 16)
                }
                Spacer()
                //
                //                HStack {
                //                    Text("최근검색")
                //                        .font(.system(size: 14, weight: .semibold))
                //
                //                    Spacer()
                //
                //                    Button {
                //
                //                    } label: {
                //                        Text("기록 삭제")
                //                            .foregroundStyle(Color(.systemGray))
                //                            .font(.system(size: 14))
                //                    }
                //                }
                //                .padding()
                //
                //                ScrollView(showsIndicators: false) {
                //                    ForEach(1...10, id: \.self) {_ in
                //                        FriendCellView(searchRightSymbol: .xmark)
                //                            .padding(.vertical, 3)
                //                    }
                //                }
            }
            .padding(.top, 15)
        }
    }
}

