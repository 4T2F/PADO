//
//  UserDefaults+.swift
//  PADO
//
//  Created by 황민채 on 2/5/24.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let combined = UserDefaults.standard
        let appGroupId = "group.com.4T2F.PADO"
        combined.addSuite(named: appGroupId)
        return combined
    }
}
