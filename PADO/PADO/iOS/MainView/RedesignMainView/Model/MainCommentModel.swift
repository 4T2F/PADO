//
//  MainCommentViewModel.swift
//  PADO
//
//  Created by 강치우 on 1/22/24.
//

import SwiftUI

struct MainComment: Identifiable {
    let id = UUID()
    let nameID: String
    let comment: String
    var commentPositionsX: String
    var commentPositionsY: String
}

final class MainCommentViewModel: ObservableObject {
    @Published var mainComments: [MainComment] = [
        MainComment(nameID: "2222", comment: "하하하, 너무 재밌네요...", commentPositionsX: "100", commentPositionsY: "100"),
        MainComment(nameID: "MinJi", comment: "그쵸! 제가 좀 재밌어요~", commentPositionsX: "105", commentPositionsY: "100"),
        MainComment(nameID: "BestCha", comment: "잘 모르겠습니다..", commentPositionsX: "110", commentPositionsY: "100"),
        MainComment(nameID: "A-heung", comment: "이런흥아흥아흥!", commentPositionsX: "115", commentPositionsY: "100"),
        MainComment(nameID: "pinkso", comment: "솔직히 저 예쁘지 않아요?", commentPositionsX: "125", commentPositionsY: "100"),
        MainComment(nameID: "pado", comment: "넌 손해 좀 보자", commentPositionsX: "135", commentPositionsY: "100"),
        MainComment(nameID: "ciu", comment: "솔직히 저 예쁘지 않아요?", commentPositionsX: "145", commentPositionsY: "100"),
        MainComment(nameID: "myunghyun", comment: "이런흥아흥아흥!", commentPositionsX: "155", commentPositionsY: "100"),
        MainComment(nameID: "minchae", comment: "솔직히 저 예쁘지 않아요?", commentPositionsX: "160", commentPositionsY: "100")
    ]
}

