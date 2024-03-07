//
//  CollectionType.swift
//  PADO
//
//  Created by 강치우 on 3/7/24.
//

import Foundation

enum CollectionType {
    case follower
    case following
    case surfer
    case surfing
    
    var collectionName: String {
        switch self {
        case .follower:
            return "follower"
        case .following:
            return "following"
        case .surfer:
            return "surfer"
        case .surfing:
            return "surfing"
        }
    }
}
