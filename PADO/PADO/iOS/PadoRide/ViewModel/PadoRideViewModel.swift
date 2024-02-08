//
//  PadoRideViewModel.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import Kingfisher
import SwiftUI

class PadoRideViewModel: ObservableObject {
    @Published var selectedImage: String = ""
    @Published var selectedUIImage: UIImage?
    @Published var postsData: [String: [Post]] = [:]
    
    let getPostData = GetPostData()
    
    // 선택된 이미지 URL을 기반으로 UIImage를 다운로드하고 저장하는 함수
    func downloadSelectedImage() {
        guard let url = URL(string: selectedImage) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                self.selectedUIImage = imageResult.image
                print("나 성공했어!")
            case .failure(let error):
                print(error)
                self.selectedUIImage = nil
            }
        }
    }
    
    // 특정 ID들에 대한 포스트 데이터를 미리 로드
    func preloadPostsData(for ids: [String]) async {
        for id in ids {
            let posts = await getPostData.suffingPostData(id: id)
            DispatchQueue.main.async {
                self.postsData[id] = posts
            }
        }
    }
}
