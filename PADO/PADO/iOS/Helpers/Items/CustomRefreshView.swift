//
//  CustomRefreshView.swift
//  PADO
//
//  Created by 최동호 on 2/8/24.
//

import Lottie
import SwiftUI

struct CustomRefreshView<Content: View>: View {
    var content: Content
    var showsIndicator: Bool
    var lottieFileName: String
    var onRefresh: () async -> Void
    
    @ObservedObject var scrollDelegate: ScrollViewModel
    
    init (showsIndicator: Bool = false,
          lottieFileName: String,
          scrollDelegate: ScrollViewModel,
          @ViewBuilder content: @escaping () -> Content,
          onRefresh: @escaping () async -> Void) {
        self.showsIndicator = showsIndicator
        self.lottieFileName = lottieFileName
        self.scrollDelegate = scrollDelegate
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicator) {
            VStack(spacing: 0){
                GeometryReader { proxy in
                    // 확장 가능한 Lottie 뷰
                    ResizbaleLottieView(fileName: lottieFileName, isPlaying: $scrollDelegate.isRefreshing)
                        .scaleEffect(scrollDelegate.isEligible ? 1 : 0.001)
                        .animation(.easeInOut(duration: 0.2), value: scrollDelegate.isEligible)
                        
                        .frame(height: 150)
                        .opacity(scrollDelegate.progress)
                        .offset(y: scrollDelegate.isEligible ?
                                -(scrollDelegate.contentOffset < 0 ?
                                  0 : scrollDelegate.contentOffset) : -(scrollDelegate.scrollOffset < 0 ?
                                                                          0 : scrollDelegate.scrollOffset))
                }
                .frame(height: 0)
                .offset(y: -75 + (75 * scrollDelegate.progress))
                
                content
                    .offset(y: scrollDelegate.progress * 150)
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                // 내용 오프셋 저장
                scrollDelegate.contentOffset = offset
                
                // 새로고침 가능할 때 진행률 멈춤
                if !scrollDelegate.isEligible{
                    var progress = offset / 150
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                // 새로고침 상태 체크 및 햅틱 피드백
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    // MARK: Haptic Feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .background(.main, ignoresSafeAreaEdges: .all)
        .scrollTargetLayout()
        .padding(.bottom, 3)
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea(.all, edges: .top)
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { _, newValue in
            // 새로고침 후 속성 재설정
            if newValue{
                Task{
                    await onRefresh()
                    withAnimation(.easeInOut(duration: 0.25)){
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
}



// MARK: 동시성 제스처를 위한 클래스
class ScrollViewModel: NSObject,ObservableObject,UIGestureRecognizerDelegate {
    // 속성
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    // 오프셋 및 진행률
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    let gestureID: String = UUID().uuidString
    
    // 유저가 화면을 떠날 때 새로고침 시작을 알기 위해
    // UI 메인 애플리케이션 창에 팬 제스처 추가
    // SwiftUI 스크롤 및 제스처 방해하지 않음
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // 제스처 추가
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        panGesture.name = gestureID
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    // 뷰 떠날 때 제스처 제거
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll(where: { gesture in
            gesture.name == gestureID
        })
    }
    
    // 루트 컨트롤러 찾기
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    // 제스처 변화 감지
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            print("User Released Touch")
            // MARK: Your Max Duration Goes Here
            if !isRefreshing {
                if scrollOffset > 70 {
                    isEligible = true
                }else{
                    isEligible = false
                }
            }
        }
    }
}

// MARK: Offset Modifier
@MainActor
extension View {
    @ViewBuilder
    func offset(coordinateSpace: String,
                offset: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader{proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}

// MARK: Offset Preference Key
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, 
                       nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: Custom Resizbale Lottie View
struct ResizbaleLottieView: UIViewRepresentable {
    var fileName: String
    @Binding var isPlaying: Bool
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        addLottieView(view: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.subviews.forEach { view in
            if view.tag == 1009, let lottieView = view as? LottieAnimationView {
                if isPlaying{
                    lottieView.play()
                }else{
                    lottieView.pause()
                }
            }
        }
    }
    
    // MARK: Adding Lottie View
    func addLottieView(view to: UIView) {
        let lottieView = LottieAnimationView(name: fileName,
                                             bundle: .main)
        lottieView.backgroundColor = .clear
        // 서브뷰에서 찾기 및 애니메이션 사용을 위한 태그 설정
        lottieView.tag = 1009
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        lottieView.loopMode = .loop
        
        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor),
        ]
        
        to.addSubview(lottieView)
        to.addConstraints(constraints)
    }
}
