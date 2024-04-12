//
//  CorpView.swift
//  PADO
//
//  Created by 황성진 on 2/1/24.
//

import PhotosUI
import SwiftUI

struct PostCropView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var surfingVM: SurfingViewModel
    @ObservedObject var feedVM: FeedViewModel
    @ObservedObject var followVM: FollowViewModel
    
    @GestureState private var isInteractig: Bool = false
    
    var crop: Crop = .rectangle
    var onCrop: (UIImage?, Bool) -> Void
    
    var body: some View {
        VStack {
            imageView()
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.main, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.main
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            surfingVM.imageChangeButton = false
                            surfingVM.selectedColor = Color.main
                        } label: {
                            Image(systemName: "arrow.up.right.and.arrow.down.left")
                                .font(.system(.body, weight: .semibold))
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            surfingVM.imageChangeButton = true
                        } label: {
                            Image(systemName: "arrow.down.backward.and.arrow.up.forward")
                                .font(.system(.body, weight: .semibold))
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            let renderer = ImageRenderer(content: imageView(true))
                            renderer.scale = 3
                            renderer.proposedSize = .init(crop.size())
                            if let image = renderer.uiImage {
                                onCrop(image, true)
                                surfingVM.postingUIImage = image
                                if let uiImage = surfingVM.postingUIImage {
                                    surfingVM.postingImage = Image(uiImage: uiImage)
                                }
                                surfingVM.showPostView.toggle()
                            } else {
                                onCrop(nil, false)
                            }
                            surfingVM.postImageItem = nil
                        } label: {
                            Text("다음")
                                .font(.system(.body, weight: .semibold))
                        }
                    }
                    
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            surfingVM.resetImage()
                            dismiss()
                            surfingVM.postImageItem = nil
                            surfingVM.resetDrag()
                        } label: {
                            Image("dismissArrow")
                        }
                    }
                }
                .navigationDestination(isPresented: $surfingVM.showPostView) {
                    PostView(surfingVM: surfingVM,
                             feedVM: feedVM,
                             followVM: followVM)
                }
                .overlay {
                    VStack {
                        Spacer()
                        ColorPicker(selection: $surfingVM.selectedColor) { }
                            .opacity(surfingVM.imageChangeButton ? 0 : 1)
                            .fixedSize()
                            .padding(.bottom, 20)
                    }
                }
        }
        .background {
            Color.main.ignoresSafeArea()
        }
    }
    
    // 이미지 뷰를 구성하는 함수
    // 이미지 뷰는 이전 화면에서 선택한 이미지
    @ViewBuilder
    func imageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        
        if !surfingVM.imageChangeButton {
            GeometryReader {
                let size = $0.size
                
                if let image = surfingVM.postingUIImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                }
            }
            .frame(cropSize)
            .background {
                if !surfingVM.imageChangeButton {
                    if surfingVM.selectedColor != Color.main {
                        surfingVM.selectedColor
                    } else {
                        Image(uiImage: surfingVM.postingUIImage ?? UIImage())
                            .blur(radius: 50)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: crop == .circle ? cropSize.height / 2 : 0))
        } else {
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
                                                surfingVM.offset.width = (surfingVM.offset.width - rect.minX)
                                                haptics(.medium)
                                            }
                                            if rect.minY > 0 {
                                                surfingVM.offset.height = (surfingVM.offset.height - rect.minY)
                                                haptics(.medium)
                                            }
                                            if rect.maxX < size.width {
                                                surfingVM.offset.width = (rect.minX - surfingVM.offset.width)
                                                haptics(.medium)
                                            }
                                            
                                            if rect.maxY < size.height {
                                                surfingVM.offset.height = (rect.minY - surfingVM.offset.height)
                                                haptics(.medium)
                                            }
                                        }
                                        if !newValue {
                                            surfingVM.lastStoredOffset = surfingVM.offset
                                        }
                                    }
                            }
                        })
                        .frame(size)
                }
            }
            .scaleEffect(surfingVM.scale)
            .offset(surfingVM.offset)
            // 그리드를 보여주는 곳
            .overlay(content: {
                if !hideGrids {
                    if surfingVM.showinGrid {
                        ImageGrid(isShowinRectangele: false)
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
                        surfingVM.offset = CGSize(width: translation.width + surfingVM.lastStoredOffset.width,
                                                  height: translation.height + surfingVM.lastStoredOffset.height)
                        surfingVM.showinGrid = true
                    })
                    .onEnded({ value in
                        surfingVM.showinGrid = false
                    })
            )
            .gesture(
                MagnificationGesture()
                    .updating($isInteractig, body: { _, out, _ in
                        out = true
                    }).onChanged({ value in
                        let updatedScale = value + surfingVM.lastScale
                        // - Limiting Beyound 1
                        surfingVM.scale = (updatedScale < 1 ? 1 : updatedScale)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if surfingVM.scale < 1 {
                                surfingVM.scale = 1
                                surfingVM.lastScale = 0
                            } else {
                                surfingVM.lastScale = surfingVM.scale - 1
                            }
                        }
                    })
            )
            .frame(cropSize)
            .clipShape(RoundedRectangle(cornerRadius: crop == .circle ? cropSize.height / 2 : 0))
        }
    }
}
