//
//  SwipeAction.swift
//  CustomSwipeActions
//
//  Created by Balaji Venkatesh on 19/11/23.
//

import SwiftUI

/// Custom Swipe Action View
struct SwipeAction<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    /// View Unique ID
    let viewID = "CONTENTVIEW"
    
    @ViewBuilder var content: Content
    
    @ActionBuilder var actions: [Action]
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                        /// To Take Full Available Space
                        .containerRelativeFrame(.horizontal)
                        .background(.main)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                
                                Color.clear
                                    .preference(key: SwipeOffsetKey.self, value: minX)
                                    .onPreferenceChange(SwipeOffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    
                    actionButtons {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    
    /// Action Buttons
    @ViewBuilder
    func actionButtons(resetPosition: @escaping () -> Void) -> some View {
        /// Each Button Will Have 100 Width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 70)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.3))
                                button.action()
                                /// Optional
                                try? await Task.sleep(for: .seconds(0.05))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 60, height: 60)
                                .contentShape(.rect)
                        })
                    }
                    Spacer()
                }
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return (minX > 0 ? -minX : 0)
    }
    
    var filteredActions: [Action] {
        return actions.filter({ $0.isEnabled })
    }
}

/// Offset Key
struct SwipeOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Custom Transition
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

/// Swipe Direction
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

/// Action Model
struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> Void
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}
