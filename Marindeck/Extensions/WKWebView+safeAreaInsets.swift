//
//  WKWebView+safeAreaInsets.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/16.
//

import WebKit

extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
