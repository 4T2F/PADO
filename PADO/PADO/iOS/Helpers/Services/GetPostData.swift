//
//  GetPostData.swift
//  PADO
//
//  Created by 황성진 on 2/8/24.
//

import Firebase
import FirebaseFirestore
import SwiftUI

class GetPostData {
    
    let db = Firestore.firestore()
    
    var postResults: [Post] = []
    
    func suffingPostData(id: String) async -> [Post] {
        let query = db.collection("post")
            .whereField("ownerUid", isEqualTo: id)
            .order(by: "created_Time", descending: true)
        
        do {
            let postData = try await query.getDocuments()
            
            self.postResults = postData.documents.compactMap { document in
                try? document.data(as: Post.self)
            }
            return postResults
        } catch {
            print("나를 지정한 서퍼의 데이터 가져오기 오류 : \(error.localizedDescription)")
        }
        return [] // 에러 처리 후 반환할 값 설정
    }
}
