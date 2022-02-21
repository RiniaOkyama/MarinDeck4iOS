//
//  UIAlertController+setContentViewController.swift
//  Marindeck
//
//  Created by a on 2022/02/21.
//

import UIKit

extension UIAlertController {
    func setContentViewController(vc: UIViewController, height: CGFloat? = nil) {
        setValue(vc, forKey: "contentViewController")
        vc.preferredContentSize.width = 300

        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
}
