//
//  OffsetPageTabView.swift
//  PADO
//
//  Created by 황민채 on 1/31/24.
//


import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var offset: CGFloat
    @Binding var selection: Int
    
    @Binding var isScrolling: Bool
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    init(selection: Binding<Int>, offset: Binding<CGFloat>, isScrolling: Binding<Bool>, @ViewBuilder content: @escaping() -> Content) {
        
        self.content = content()
        self._offset = offset
        self._selection = selection
        self._isScrolling = isScrolling
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollview = UIScrollView()
        
        let hostview = UIHostingController(rootView: content)
        hostview.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
        
            hostview.view.topAnchor.constraint(equalTo: scrollview.topAnchor),
            hostview.view.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            hostview.view.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            hostview.view.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            
            hostview.view.heightAnchor.constraint(equalTo: scrollview.heightAnchor)
        ]
        
        scrollview.addSubview(hostview.view)
        scrollview.addConstraints(constraints)
        
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        
        scrollview.delegate = context.coordinator
        
        return scrollview
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        let currentOffset = uiView.contentOffset.x
        
        if currentOffset != offset{
        
            print("updating")
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate{
        
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            let maxSize = scrollView.contentSize.width
            let currentSelection = (offset / maxSize).rounded()
            
            parent.selection = Int(currentSelection)
            parent.isScrolling = (scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating)
            parent.offset = offset
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.isScrolling = false
        }
    }
}
