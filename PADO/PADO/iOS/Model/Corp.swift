//
//  Corp.swift
//  PADO
//
//  Created by 황성진 on 2/1/24.
//

import SwiftUI

enum Crop: Equatable {
    case circle
    case rectangle
    
    func name() -> String {
        switch self {
        case .circle:
            return "circle"
        case .rectangle:
            return "Rectangle"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle:
            return .init(width: 300, height: 300)
        case .rectangle:
            return .init(width: 300, height: 500)
        }
    }
}
