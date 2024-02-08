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
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var followVM: FollowViewModel
    
    @FocusState private var isTextFieldFocused: Bool
    
    let updateFollowData = UpdateFollowData()
    // MARK: - BODY
    var body: some View {
        let searchTextBinding = Binding {
            return mainSearch
        } set: {
            mainSearch = $0
            searchVM.updateSearchText(with: $0)
        }
        NavigationStack {
            ZStack {
                Color.main.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("검색")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.leading)
                    
                    SearchBar(text: searchTextBinding,
                              isLoading: $searchVM.isLoading)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        isTextFieldFocused = true
                    }
                    .padding(.horizontal)
                    
                    if mainSearch.isEmpty {
                        if !searchVM.searchDatas.isEmpty {
                            HStack {
                                Text("최근검색")
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Spacer()
                                
                                Button {
                                    searchVM.clearSearchData()
                                } label: {
                                    Text("기록 삭제")
                                        .foregroundStyle(Color(.systemGray))
                                        .font(.system(size: 14))
                                }
                            }
                            .padding()
                            
                            ScrollView(showsIndicators: false) {
                                ForEach(searchVM.searchDatas.reversed(), id: \.self) { searchData in
                                    RecordSearchCellView(profileVM: profileVM,
                                                         followVM: followVM,
                                                         searchVM: searchVM,
                                                         searchCellID: searchData,
                                                         updateFollowData: updateFollowData)
                                    .padding(.vertical, 3)
                                }
                            }
                        } else {
                            SearchGuide()
                                .padding(.top, 150)
                        }
                    } else if searchVM.viewState == .empty {
                        HStack(alignment: .center) {
                            Text("검색 결과가 없습니다")
                                .foregroundColor(.gray)
                                .font(.system(size: 16,
                                              weight: .semibold))
                                .padding(.top, 150)
                        }
                    } else if searchVM.viewState == .ready {
                        ScrollView(showsIndicators: false) {
                            ForEach(searchVM.searchResults) { result in
                                SearchCellView(profileVM: profileVM,
                                               followVM: followVM,
                                               searchVM: searchVM,
                                               user: result, 
                                               updateFollowData: updateFollowData)
                                .padding(.vertical, 3)
                            }
                        }
                        .padding(.top, 16)
                    }
                    Spacer()
                    
                }
                .padding(.top, 15)
            }
        }
    }
}

