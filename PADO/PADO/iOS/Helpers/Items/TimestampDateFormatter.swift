//
//  DateFormatter.swift
//  PADO
//
//  Created by 최동호 on 1/29/24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

class TimestampDateFormatter {
    static func formatDate(_ timestamp: Timestamp) -> String {
        let currentDate = Date() // 현재 날짜 및 시간
        let date = timestamp.dateValue() // Timestamp를 Date로 변환
        let calendar = Calendar.current

        let hoursAgo = calendar.dateComponents([.hour], from: date, to: currentDate).hour ?? 0
        let minutesAgo = calendar.dateComponents([.minute], from: date, to: currentDate).minute ?? 0
        let secondsAgo = calendar.dateComponents([.second], from: date, to: currentDate).second ?? 0
        
        switch hoursAgo {
        case 24...:
            // 1일보다 오래된 경우
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd. a h:mm" // AM/PM을 포함하는 날짜 형식 지정
            formatter.amSymbol = "오전"
            formatter.pmSymbol = "오후"
            return formatter.string(from: date)
        case 1...:
            // 1시간 이상, 1일 미만
            return "\(hoursAgo)시간 전"

        default:
            // 1시간 미만
            if minutesAgo >= 1 {
                return "\(minutesAgo)분 전"
            } else {
                return "\(secondsAgo)초 전"
            }
        }
    }
}
