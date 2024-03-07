//
//  FeedFilterType.swift
//  PADO
//
//  Created by 강치우 on 3/7/24.
//

import Foundation

enum FeedFilter: Int, CaseIterable, Identifiable {
    case following
    case today
    
    var title: String {
        switch self {
        case .following: return "Following"
        case .today: return "Today"
        }
    }
    var id: Int { return self.rawValue }
}
