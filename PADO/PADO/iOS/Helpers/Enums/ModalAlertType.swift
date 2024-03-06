//
//  ModalAlertType.swift
//  PADO
//
//  Created by 최동호 on 3/7/24.
//

import Foundation

enum ModalAlertTitle: String {
    case cash = "캐시 지우기"
    case account = "계정 삭제"
    case signOut = "로그아웃"
}

enum ModalAlertSubTitle: String {
    case cash = "캐시를 지우면 일부 문제가 해결될 수 있습니다"
    case account = "한번 삭제된 계정은 복원되지 않습니다. 정말 삭제하시겠어요?"
    case signOut = "현재 계정에서 로그아웃 하시겠어요?"
}

enum ModalAlertRemove: String {
    case cash = "PADO 캐시 지우기"
    case account = "계정 삭제"
    case signOut = "로그아웃"
}
