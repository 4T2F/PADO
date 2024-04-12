//
//  DateETC.swift
//  PADO
//
//  Created by 황민채 on 4/1/24.
//

import FirebaseFirestore
import FirebaseStorage

import SwiftUI

// Timestamp 형식의 시간을 가져와서 날짜 및 시간 형식으로 변환
extension Timestamp {
    func formatDate(_ timestamp: Timestamp) -> String {
        let currentDate = Date() // 현재 날짜 및 시간
        let date = timestamp.dateValue() // Timestamp를 Date로 변환
        let calendar = Calendar.current
        
        let yearsAgo = calendar.dateComponents([.year], from: date, to: currentDate).year ?? 0
        let monthsAgo = calendar.dateComponents([.month], from: date, to: currentDate).month ?? 0
        let weeksAgo = calendar.dateComponents([.weekOfMonth], from: date, to: currentDate).weekOfMonth ?? 0
        let daysAgo = calendar.dateComponents([.day], from: date, to: currentDate).day ?? 0
        
        switch yearsAgo {
        case 1...:
            // 1년 이상
            return "\(yearsAgo)년"
        default:
            switch monthsAgo {
            case 1...:
                // 1달 이상
                return "\(monthsAgo)달"
            default:
                switch weeksAgo {
                case 1...:
                    // 1주 이상
                    return "\(weeksAgo)주"
                default:
                    // 1일 이상
                    if daysAgo >= 1 {
                        return "\(daysAgo)일"
                    } else {
                        // 1일 미만
                        let hoursAgo = calendar.dateComponents([.hour], from: date, to: currentDate).hour ?? 0
                        let minutesAgo = calendar.dateComponents([.minute], from: date, to: currentDate).minute ?? 0
                        let secondsAgo = calendar.dateComponents([.second], from: date, to: currentDate).second ?? 0
                        
                        switch hoursAgo {
                        case 1...:
                            // 1시간 이상, 1일 미만
                            return "\(hoursAgo)시간"
                            
                        default:
                            // 1시간 미만
                            if minutesAgo >= 1 {
                                return "\(minutesAgo)분"
                            } else {
                                return "\(secondsAgo)초"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func convertTimestampToString(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue() // Timestamp를 Date로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.sssZ" // 원하는 날짜 형식 설정
        let dateString = dateFormatter.string(from: date) // Date를 String으로 변환
        return dateString
    }
}

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
