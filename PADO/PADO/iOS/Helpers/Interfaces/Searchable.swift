//
//  Searchable.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import SwiftUI

// 공통된 기능을 정의하는 프로토콜
protocol Searchable: AnyObject {
    var isLoading: Bool { get set }
    var progress: Double { get set }
    var searchResults: [User] { get set }
    var viewState: ViewState { get set }
    
    func updateSearchText(with text: String)
    func getSearchResults(forText text: String)
    func setViewState(to state: ViewState)
}

// 프로토콜 확장을 사용하여 기본 구현 제공
extension Searchable {
    func updateSearchText(with text: String) {
        setViewState(to: .loading)
        if text.count > 0 {
            getSearchResults(forText: text)
        }
    }
    
    func getSearchResults(forText text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.searchResults.count == 0 {
                self.setViewState(to: .empty)
            } else {
                self.setViewState(to: .ready)
            }
        }
    }
    
    func setViewState(to state: ViewState) {
        DispatchQueue.main.async {
            self.viewState = state
            self.isLoading = state == .loading
        }
    }
}
