//
//  UserProfileImageView.swift
//  PADO
//
//  Created by 강치우 on 3/8/24.
//

import Kingfisher

import SwiftUI

struct UserProfileImageView: View {
    @Binding var isTouched: Bool
    @Binding var isDragging: Bool
    @Binding var position: CGSize
    
    let imageUrl: URL?

    var body: some View {
        KFImage(imageUrl)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: isDragging ? 12 : 0))
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                    self.isTouched = false
                }
            }
            .offset(position)
            .highPriorityGesture(
                DragGesture()
                    .onChanged({ value in
                        self.position = value.translation
                        self.isDragging = true
                    })
                    .onEnded({ value in
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.8)) {
                            if 200 < abs(self.position.height) {
                                self.isTouched = false
                                self.isDragging = false
                            } else {
                                self.position = .zero
                                self.isDragging = false
                            }
                        }
                    })
            )
    }
}
