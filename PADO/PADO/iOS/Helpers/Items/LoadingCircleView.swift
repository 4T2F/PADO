//
//  LoadingCircleView.swift
//  PADO
//
//  Created by 최동호 on 1/23/24.
//

import SwiftUI

struct LoadingCircleView: View {
    @State private var circleRotates = [Bool](repeating: false, count: 8)
    @State private var rotateEntire = false

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            
            
            ForEach(0..<8) { index in
                createRectangle(index: index)
            }
            .rotationEffect(.degrees(rotateEntire ? 0 : 180))
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: rotateEntire)
        }
        .onAppear {
            rotateEntire.toggle()
        }
    }

    func createRectangle(index: Int) -> some View {
        Rectangle()
            .foregroundColor(colorForIndex(index))
            .cornerRadius(circleRotates[index] ? 50 : 90)
            .frame(width: 15, height: 5)
            .overlay(
                circleRotates[index] ? RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1) : RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1)
            )
            .opacity(circleRotates[index] ? 0.5 : 1)
            .scaleEffect(circleRotates[index] ? 0.4 : 1)
            .rotationEffect(.degrees(circleRotates[index] ? 90 : -90))
            .offset(x: 0, y: 10)
            .rotationEffect(.degrees(Double(index) * 45))
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: circleRotates[index])
            .onAppear {
                circleRotates[index].toggle()
            }
    }

    func colorForIndex(_ index: Int) -> Color {
        let opacity = 1.0 - Double(index) * 0.1
        return index < 4 ? Color.white.opacity(opacity) : Color.white.opacity(opacity)
    }
}

#Preview {
    LoadingCircleView()
}
