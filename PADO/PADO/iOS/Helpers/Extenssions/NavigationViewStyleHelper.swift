//
//  NavigationViewStyleHelper.swift
//  PADO
//
//  Created by 강치우 on 1/4/24.
//

import SwiftUI

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
