//
//  ViewState.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import Foundation

enum ViewState: String {
    case empty
    case loading
    case ready
    case error
}

enum MyError: Error {
    case invalidURL
}
