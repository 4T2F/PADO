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
    
    // since we need to get the drawings so were binding...
    @Binding var canvas: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    
    // View Size..
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput

        // appending the image in canvas subview...
        if let image = padorideVM.selectedUIImage {
            
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: -50, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            // basically were setting image to the back of the canvas...
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            // showing tool picker...
            // were setting it as first responder and making it as visible...
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
        // Update UI will update for each actions...
    }
        
    
}

