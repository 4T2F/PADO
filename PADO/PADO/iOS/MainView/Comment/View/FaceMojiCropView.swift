//
//  FaceMojiCropView.swift
//  PADO
//
//  Created by 황성진 on 2/4/24.
//

import PhotosUI
import SwiftUI

struct FaceMojiCropView: View {
    // MARK: - PROPERTY
    @Environment(\.dismiss) var dismiss
    
    // 이미지 조작을 위한 상태 변수들
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @State private var showinGrid: Bool = false
    @GestureState private var isInteractig: Bool = false
    
    @ObservedObject var commentVM: CommentViewModel

    
    @Binding var postOwner: User
    
    var crop: Crop = .circle
    let postID: String
    
    var onCrop: (UIImage?, Bool) -> Void
    
    var body: some View {
        imageView()
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
            .navigationDestination(isPresented: $commentVM.showEmojiView) {
                SelectEmojiView(commentVM: commentVM,
                                postOwner: $postOwner,
                                postID: postID)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let renderer = ImageRenderer(content: imageView(true))
                        renderer.scale = 3
                        renderer.proposedSize = .init(crop.size())
                        if let image = renderer.uiImage {
                            onCrop(image, true)
                            commentVM.cropMojiUIImage = image
                            commentVM.cropMojiImage = Image(uiImage: image)
                        } else {
                            onCrop(nil, false)
                        }
                        commentVM.showEmojiView = true
                    } label: {
                        Text("이모지 선택")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        commentVM.showCropFaceMoji = false
                    } label: {
                        Image("dismissArrow")
                    }
                }
            }
    }
    
    // 이미지 뷰를 구성하는 함수
    // 이미지 뷰는 이전 화면에서 선택한 이미지
    @ViewBuilder
    func imageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image = commentVM.faceMojiUIImage {
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
                    grids()
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
    func grids() -> some View {
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
