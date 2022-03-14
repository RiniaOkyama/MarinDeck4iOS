//
//  UIViewController+setSwipeBack.swift
//  Marindeck
//
//  Created by a on 2022/03/09.
//

import UIKit

extension UIViewController {
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}
