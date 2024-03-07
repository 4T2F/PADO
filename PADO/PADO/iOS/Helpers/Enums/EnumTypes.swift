//
//  EnumTypes.swift
//  PADO
//
//  Created by 강치우 on 3/7/24.
//

import SwiftUI

// 팔로워 모달 타입
enum FollowerModalType {
    case surfer
    case follower
}

// 서퍼 관련
enum SufferSet: String {
    case removesuffer = "서퍼 해제"
    case setsuffer = "서퍼 등록"
}

// 팔로워 팔로잉 관련
enum SearchFollowType {
    case follower
    case following
}

// 팔로워 팔로잉 관련
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

// 포토모지 관련
enum Emotion: String, CaseIterable {
    case basic = ""
    case thumbsUp = "👍"
    case heart = "🥰"
    case laughing = "🤣"
    case angry = "😡"
    case sad = "😢"
    case overEat = "🤮"
    
    var emoji: String {
        self.rawValue
    }
    
    var color: Color {
        switch self {
        case .basic:
            return .white
        case .thumbsUp:
            return .green
        case .heart:
            return .pink
        case .laughing:
            return .yellow
        case .angry:
            return .orange
        case .sad:
            return .blue
        case .overEat:
            return .purple
        }
    }
}

// 댓글 관련
enum CommentType {
    case comment
    case replyComment
}

// 게시물 크롭 관련
enum PostViewType {
    case receive
    case send
    case highlight
}

// 프로필 그리드 관련
enum InputPostType {
    case pado
    case sendPado
    case highlight
}

// 피드 상단 팔로잉, 투데이
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

// 버튼 타입
enum ButtonType {
    case direct
    case unDirect
}

// 이미지 크롭 관련
enum Crop: Equatable {
    case circle
    case rectangle
    case backImage
    
    func name() -> String {
        switch self {
        case .circle:
            return "circle"
        case .rectangle:
            return "Rectangle"
        case .backImage:
            return "BackImage"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle:
            return .init(width: 300, height: 300)
        case .rectangle:
            return .init(width: 300, height: 500)
        case .backImage:
            return .init(width: UIScreen.main.bounds.width * 1.0, height: 400)
        }
    }
}

// 모달 타입 관련
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

enum ViewState: String {
    case empty
    case loading
    case ready
    case error
}
