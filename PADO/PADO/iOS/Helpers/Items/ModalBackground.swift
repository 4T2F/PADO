//
//  ModalBackground.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

// MARK: - Modal이 열릴 때 뒷배경을 투명으로 처리해주는 아이입니다. 많관부
import SwiftUI

struct ClearBackground: UIViewRepresentable {
    
    public func makeUIView(context: Context) -> UIView {
        let view = ClearBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
}

class ClearBackgroundView: UIView {
    open override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}
