//
//  CommentViewModel.swift
//  PADO
//
//  Created by 최동호 on 2/8/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var documentID: String = ""
    @Published var inputcomment: String = ""
    @Published var showdeleteModal: Bool = false
    @Published var showreportModal: Bool = false
    @Published var showselectModal: Bool = false
    @Published var selectedComment: Comment?
    
    let updateCommentData = UpdateCommentData()
    
    // MARK: - FaceMoji 관련
    @Published var faceMojiUIImage: UIImage?
    @Published var cropMojiUIImage: UIImage?
    @Published var cropMojiImage: Image = Image("")
    @Published var facemojies: [Facemoji] = []
    @Published var deleteFacemojiModal: Bool = false
    @Published var showCropFaceMoji: Bool = false
    @Published var showEmojiView: Bool = false
    @Published var selectedEmoji: String = ""
    @Published var selectedFacemoji: Facemoji?
    
    let updateFacemojiData = UpdateFacemojiData()
    
}
