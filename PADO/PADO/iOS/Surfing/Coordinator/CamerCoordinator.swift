//
//  CamerCoordinator.swift
//  PADO
//
//  Created by 최동호 on 1/25/24.
//

import Foundation
import SwiftUI

// UIImagePickerController와의 상호작용을 처리하기 위한 코디네이터 클래스
class CameraCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isShown: Bool
    @Binding var myimage: Image
    
    init(isShown: Binding<Bool>, myimage: Binding<Image>) {
        _isShown = isShown
        _myimage = myimage
    }
    
    // 이미지 선택이 완료되었을때 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            myimage = Image.init(uiImage: image)
        }
        isShown = false
    }
    
    // 이미지 선택이 취소 되었을 때 호출
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
