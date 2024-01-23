//
//  MainFaceMojiModel.swift
//  PADO
//
//  Created by 황민채 on 1/23/24.
//

import SwiftUI

struct MainFaceMoji: Identifiable {
    let id = UUID()
    let emotionPhoto: String
    let emotion: Emotion
    var faceMojiPositionsX: String
    var faceMojiPositionsY: String
}

final class MainFaceMojiViewModel: ObservableObject {
    @Published var mainFaceMoji: [MainFaceMoji] = [
        MainFaceMoji(emotionPhoto: "pp", emotion: .heart, faceMojiPositionsX: "15", faceMojiPositionsY: "20"),
        MainFaceMoji(emotionPhoto: "pp", emotion: .angry, faceMojiPositionsX: "25", faceMojiPositionsY: "20"),
        MainFaceMoji(emotionPhoto: "pp", emotion: .laughing, faceMojiPositionsX: "35", faceMojiPositionsY: "20"),
        MainFaceMoji(emotionPhoto: "pp", emotion: .overEat, faceMojiPositionsX: "45", faceMojiPositionsY: "20"),
        MainFaceMoji(emotionPhoto: "pp", emotion: .sad, faceMojiPositionsX: "55", faceMojiPositionsY: "20"),
        MainFaceMoji(emotionPhoto: "pp", emotion: .thumbsUp, faceMojiPositionsX: "65", faceMojiPositionsY: "20")
    ]
}
