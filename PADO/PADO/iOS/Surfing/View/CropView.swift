//
//  CorpView.swift
//  PADO
//
//  Created by 황성진 on 2/1/24.
//

import PhotosUI
import SwiftUI

struct CropView: View {
    // MARK: - PROPERTY
    @Environment(\.dismiss) var dismiss
    
    // 이미지 조작을 위한 상태 변수들
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @State private var showinGrid: Bool = false
    @GestureState private var isInteractig: Bool = false
    @GestureState private var forGridpress: Bool = false
    
    @ObservedObject var surfingVM: SurfingViewModel
    
    var crop: Crop = .rectangle
    var onCrop: (UIImage?, Bool) -> Void
    
    var body: some View {
        NavigationStack {
            ImageView()
                .navigationTitle("편집")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // UIImage로 변환을 시도
                            if let uiImage = surfingVM.postingUIImage {
                                // UIGraphicsImageRenderer를 사용하여 이미지 렌더링
                                let renderer = UIGraphicsImageRenderer(size: uiImage.size)
                                let renderedImage = renderer.image { _ in
                                    uiImage.draw(in: CGRect(origin: .zero, size: uiImage.size))
                                }
                                // 렌더링된 이미지를 사용
                                onCrop(renderedImage, true)
                                surfingVM.postingImage = Image(uiImage: renderedImage)
                            } else {
                                onCrop(nil, false)
                            }
                            surfingVM.showPostView.toggle()
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            surfingVM.resetImage()
                            dismiss()
                        } label: {
                            Image("dismissArrow")
                        }
                    }
                }
        }
        .navigationDestination(isPresented: $surfingVM.showPostView) {
            PostView(surfingVM: surfingVM)
        }
    }
    
    // 이미지 뷰를 구성하는 함수
    // 이미지 뷰는 이전 화면에서 선택한 이미지
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image = surfingVM.postingUIImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteractig) { oldValue, newValue in
                                    // 드래그, 핀치 제스처 에 대한 내용
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxY < size.height {
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    if !newValue {
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        // 그리드를 보여주는 곳
        .overlay(content: {
            if !hideGrids {
                if showinGrid {
                    Grids()
                }
            }
        })
        .coordinateSpace(name: "CROPVIEW")
        // 드래그 제스쳐를 통해서 그리드를 보여주고 안보여줌
        .gesture(
            DragGesture()
                .updating($isInteractig, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                    showinGrid = true
                })
                .onEnded({ value in
                    showinGrid = false
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteractig, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    // - Limiting Beyound 1
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .clipShape(RoundedRectangle(cornerRadius: crop == .circle ? cropSize.height / 2 : 0))
    }
    // 격자 뷰를 구성하는 함수
    @ViewBuilder
    func Grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...2, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(1...3, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

extension View {
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self // 자를때 프레임
            .frame(width: size.width, height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
