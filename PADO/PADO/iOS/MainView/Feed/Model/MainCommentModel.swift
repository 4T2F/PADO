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
        MainComment(nameID: "pado", comment: "넌 손해 좀 보자", commentPositionsX: 200, commentPositionsY: 150),
        MainComment(nameID: "apple", comment: "그쵸! 제가 좀 재밌어요~", commentPositionsX: 200, commentPositionsY: 150),
        MainComment(nameID: "legend", comment: "잘 모르겠습니다..", commentPositionsX: 250, commentPositionsY: 200),
        MainComment(nameID: "rallo", comment: "이런흥아흥아흥!", commentPositionsX: 115, commentPositionsY: 100),
        MainComment(nameID: "minchae", comment: "ㅋㅋㅋ넌 나가라", commentPositionsX: 115, commentPositionsY: 100)
    ]
}

