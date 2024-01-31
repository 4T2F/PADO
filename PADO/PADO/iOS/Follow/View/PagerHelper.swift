//
//  PagerHelper.swift
//  PADO
//
//  Created by 황민채 on 1/31/24.
//

import SwiftUI

struct PagerTabView<Content: View,Label: View>: View {
    
    var content: Content
    var label: Label
    var tint: Color
    
    @Binding var selection: Int
    
    init(tint: Color,selection: Binding<Int>, @ViewBuilder labels: @escaping() -> Label, @ViewBuilder content: @escaping() -> Content) {
        self.content = content()
        self.label = labels()
        self.tint = tint
        self._selection = selection
    }
    
    @State var offset: CGFloat = 0
    
    @State var maxTabs: CGFloat = 0
    
    @State var tabOffset: CGFloat = 0
    
    @State var isScrolling: Bool = false
    
    var body: some View {
       
        VStack(spacing: 0){
            HStack(spacing: 0){
                label
            }
            .overlay(
                HStack(spacing: 0) {
                    ForEach(0..<Int(maxTabs),id: \.self) { index in
                        Rectangle()
                            .fill(Color.clear)
                            .onTapGesture {
                                let newOffset = CGFloat(index) * getScreenBounds().width
                                self.offset = newOffset
                                withAnimation{
                                    self.tabOffset = CGFloat(index) * (getScreenBounds().width / maxTabs)
                                }
                            }
                    }
                }
            )
            .foregroundColor(tint)
            
            Capsule()
                .fill(Color.white.opacity(0.7))
                .frame(width: maxTabs == 0 ? 0 : (getScreenBounds().width / maxTabs), height: 2)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: tabOffset)
            
            OffsetPageTabView(selection: $selection,offset: $offset,isScrolling: $isScrolling) {
                
                HStack(spacing: 0) {
                    content
                }
                .overlay(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: proxy.frame(in: .global))
                    }
                )
                .onPreferenceChange(TabPreferenceKey.self) { proxy in
                    
                    let minX = -proxy.minX
                    let maxWidth = proxy.width
                    let screenWidth = getScreenBounds().width
                    let maxTabs = (maxWidth / screenWidth).rounded()
                    
                    let progress = minX / screenWidth
                    let tabOffset = progress * (screenWidth / maxTabs)
                    // print("\(isScrolling) = \(tabOffset)")
                    self.tabOffset = (isScrolling ? tabOffset : self.tabOffset)
                    
                    self.maxTabs = maxTabs
                }
            }
        }
    }
}

struct TabPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .init()
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func pageLabel() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    func pageView(ignoresSafeArea: Bool = true, edges: Edge.Set = []) -> some View {
        self
            .frame(width: getScreenBounds().width, alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(), edges: edges)
    }
    
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
