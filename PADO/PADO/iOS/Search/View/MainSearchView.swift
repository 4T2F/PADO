//
//  MainSearchView.swift
//  PADO
//
//  Created by 황성진 on 1/18/24.
//

import SwiftUI

struct MainSearchView: View {
    // MARK: - PROPERTY
    @StateObject var searchVM = SearchViewModel.shared
    
    @ObservedObject var profileVM: ProfileViewModel
    
    @State var mainSearch: String = ""
    
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return mainSearch
        } set: {
            mainSearch = $0
            searchVM.updateSearchText(with: $0)
        }
        NavigationStack {
            VStack {
                VStack(alignment: .center, spacing: 0) {
                    SearchBar(text: searchTextBinding,
                              isLoading: $searchVM.isLoading)
                    .padding(.horizontal)
                    
                    if mainSearch.isEmpty {
                        if !searchVM.searchDatas.isEmpty {
                            HStack {
                                Text("최근검색")
                                    .font(.system(.subheadline, weight: .semibold))
                                
                                Spacer()
                                
                                Button {
                                    searchVM.clearSearchData()
                                } label: {
                                    Text("기록 삭제")
                                        .foregroundStyle(Color(.systemGray))
                                        .font(.system(.subheadline))
                                }
                            }
                            .padding()
                            
                            ScrollView(showsIndicators: false) {
                                ForEach(searchVM.searchDatas.reversed(), id: \.self) { searchData in
                                    RecordSearchCellView(profileVM: profileVM,
                                                         
                                                         searchVM: searchVM,
                                                         searchCellID: searchData)
                                    .padding(.vertical, 3)
                                }
                            }
                        } else {
                            SearchGuide()
                                .padding(.top, 150)
                        }
                    } else if searchVM.viewState == .empty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.gray)
                            .font(.system(.subheadline,
                                          weight: .medium))
                            .padding(.top, 150)
                        
                    } else if searchVM.viewState == .ready {
                        ScrollView(showsIndicators: false) {
                            ForEach(searchVM.searchResults) { result in
                                SearchCellView(profileVM: profileVM,
                                               searchVM: searchVM,
                                               user: result)
                                .padding(.vertical, 3)
                            }
                        }
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                }
            }
            .background(.main, ignoresSafeAreaEdges: .all)
            .navigationTitle("검색")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

