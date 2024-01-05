//
//  PhoneumberTFFormat.swift
//  PADO
//
//  Created by 최동호 on 1/5/24.
//

import Foundation

class PhoneumberTFFormat {
    func formatPhoneNumber(_ number: String) -> String {
        let cleanNumber = number.filter("0123456789".contains)
        let mask = "XXX-XXXX-XXXX"
        
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask where index < cleanNumber.endIndex {
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
