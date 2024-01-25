//
//  MainFaceMojiModel.swift
//  PADO
//
//  Created by 황민채 on 1/23/24.
//

import SwiftUI

struct MainFaceMoji: Identifiable {
    let id = UUID()
    let nameID: String
    let emotionPhoto: String
    let emotion: Emotion
    var faceMojiPositionsX: Int
    var faceMojiPositionsY: Int
}

final class MainFaceMojiViewModel: ObservableObject {
    @Published var mainFaceMoji: [MainFaceMoji] = [
        MainFaceMoji(nameID: "2222", emotionPhoto: "pp", emotion: .heart, faceMojiPositionsX: 100, faceMojiPositionsY: 200),
        MainFaceMoji(nameID: "apple", emotionPhoto: "pp", emotion: .angry, faceMojiPositionsX: 77, faceMojiPositionsY: 65),
        MainFaceMoji(nameID: "legend", emotionPhoto: "pp", emotion: .laughing, faceMojiPositionsX: 100, faceMojiPositionsY: 200),
        MainFaceMoji(nameID: "rallo", emotionPhoto: "pp", emotion: .overEat, faceMojiPositionsX: 145, faceMojiPositionsY: 120),
        MainFaceMoji(nameID: "minchae", emotionPhoto: "pp", emotion: .sad, faceMojiPositionsX: 150, faceMojiPositionsY: 50),
        MainFaceMoji(nameID: "pado", emotionPhoto: "pp", emotion: .thumbsUp, faceMojiPositionsX: 165, faceMojiPositionsY: 20)
    ]
}
