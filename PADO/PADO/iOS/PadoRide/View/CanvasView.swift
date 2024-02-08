//
//  CanvasView.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import PencilKit
import SwiftUI

struct CanvasView: UIViewRepresentable {
    @ObservedObject var padorideVM: PadoRideViewModel
    
    @Binding var canvas: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        let imageView = UIImageView(image: padorideVM.selectedUIImage)
        imageView.frame = CGRect(x: 0, y: -50, width: rect.width, height: rect.height)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let subView = canvas.subviews[0]
        subView.addSubview(imageView)
        subView.sendSubviewToBack(imageView)
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }

}

