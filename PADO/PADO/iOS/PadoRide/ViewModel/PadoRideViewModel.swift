//
//  PadoRideViewModel.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import Kingfisher
import PencilKit
import SwiftUI

class PadoRideViewModel: ObservableObject {
//    @Published var suffingPost: [Post]
    
    @Published var selectedImage: String = ""
    @Published var selectedUIImage: UIImage?
    @Published var postsData: [String: [Post]] = [:]
    
    @Published var showImagePicker = false
    @Published var isShowingEditView: Bool = false
    @Published var imageData: Data = Data(count: 0)
    
    // Canvas for drawing...
    @Published var canvas = PKCanvasView()
    // Tool picker..
    @Published var toolPicker = PKToolPicker()
    
    // List Of TextBoxes...
    @Published var textBoxes : [TextBox] = []
    
    @Published var addNewBox = false
    
    // Current Index...
    @Published var currentIndex : Int = 0
    
    // Saving The View Frame Size...
    @Published var rect: CGRect = .zero
    
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
    
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
    
    // cancel the text view..
    func cancelTextView() {
        
        // showing again the tool bar...
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation{
            addNewBox = false
        }
        
        // removing if cancelled..
        // avoiding the removal of already added....
        if textBoxes[currentIndex].isAdded{
         
            textBoxes.removeLast()
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
