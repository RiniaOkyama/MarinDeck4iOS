//
//  UIView+.swift
//  Marindecker
//
//  Created by Rinia on 2021/01/13.
//

import Foundation
import UIKit


extension UIView {
  func anchorAll(equalTo: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: equalTo.topAnchor, constant: 0).isActive = true
    leftAnchor.constraint(equalTo: equalTo.leftAnchor, constant: 0).isActive = true
    bottomAnchor.constraint(equalTo: equalTo.bottomAnchor, constant: 0).isActive = true
    rightAnchor.constraint(equalTo: equalTo.rightAnchor, constant: 0).isActive = true
  }
}
