//
//  PhotoPicker.swift
//  PADO
//
//  Created by 최동호 on 1/25/24.
//


import Photos
import PhotosUI
import SwiftUI

// PHPickerViewController를 사용하는 SwiftUI 뷰
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var pickerResult: [PHPickerResult]
    @Binding var selectedImage: UIImage?
    // Image 타입으로 변환된 이미지를 위한 새로운 바인딩
    @Binding var selectedSwiftUIImage: Image
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1 // 0으로 설정하면 무제한 선택 가능
        config.disabledCapabilities = .selectionActions
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        // PHPickerViewController에서 사진을 선택한 후 호출됩니다.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.pickerResult = results
            
            guard !results.isEmpty else { return }
            let itemProvider = results[0].itemProvider
            
            // 선택된 사진의 데이터를 가져옵니다.
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.parent.selectedImage = image
                            // UIImage를 Image로 변환
                            self.parent.selectedSwiftUIImage = Image(uiImage: image)
                        }
                    }
                }
            }
        }
    }
}

