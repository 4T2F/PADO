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
    var commentPositionsX: Int
    var commentPositionsY: Int
}

final class MainCommentViewModel: ObservableObject {
    @Published var mainComments: [MainComment] = [
        MainComment(nameID: "2222", comment: "하하하, 너무 재밌네요...", commentPositionsX: 200, commentPositionsY: 150),
        MainComment(nameID: "MinJi", comment: "그쵸! 제가 좀 재밌어요~", commentPositionsX: 200, commentPositionsY: 150),
        MainComment(nameID: "BestCha", comment: "잘 모르겠습니다..", commentPositionsX: 250, commentPositionsY: 200),
        MainComment(nameID: "A-heung", comment: "이런흥아흥아흥!", commentPositionsX: 115, commentPositionsY: 100)

    ]
}

