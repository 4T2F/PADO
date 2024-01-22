//
//  CommentViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let comment: String
    let time: String
}

final class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = [
        Comment(username: "Yangbaechu", comment: "하하하, 너무 재밌네요...", time: "1분 전"),
        Comment(username: "MinJi", comment: "그쵸! 제가 좀 재밌어요~", time: "3분 전"),
        Comment(username: "BestCha", comment: "잘 모르겠습니다..", time: "4분 전"),
        Comment(username: "A-heung", comment: "이런흥아흥아흥!", time: "5분 전"),
        Comment(username: "pinkso", comment: "솔직히 저 예쁘지 않아요?", time: "8분 전"),
        Comment(username: "dongho", comment: "이런흥아흥아흥!", time: "13분 전"),
        Comment(username: "ciu", comment: "솔직히 저 예쁘지 않아요?", time: "15분 전"),
        Comment(username: "myunghyun", comment: "이런흥아흥아흥!", time: "17분 전"),
        Comment(username: "minchae", comment: "솔직히 저 예쁘지 않아요?", time: "24분 전")
    ]
}
