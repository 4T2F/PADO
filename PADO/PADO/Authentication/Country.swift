//
//  Country.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import Foundation
import SwiftUI

public struct Country: Codable {
    public var phoneCode: String
    public let isoCode: String

    public init(phoneCode: String, isoCode: String) {
        self.phoneCode = phoneCode
        self.isoCode = isoCode
    }

    public init(isoCode: String) {
        self.isoCode = isoCode
        phoneCode = ""
        if let country = Country.allCountries.first(where: { $0.isoCode == isoCode }) {
            self.phoneCode = country.phoneCode
        }
    }
    
    static let allCountries: [Country] = Bundle.main.decode(file: "countries.json")
}

public extension Country {
    /// Returns localized country name for localeIdentifier
    var localizedName: String {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: isoCode])
        let name = NSLocale(localeIdentifier: NSLocale.current.identifier)
            .displayName(forKey: NSLocale.Key.identifier, value: id) ?? isoCode
        return name
    }
    
    func flag(country: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return String(s)
    }
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Couldn't find file \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Couldn't find file \(file) in the project")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Couldn't find file \(file) in the project")
        }
        
        return loadedData
    }
}
