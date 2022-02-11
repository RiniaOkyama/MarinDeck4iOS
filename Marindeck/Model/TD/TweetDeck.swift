//
//  TweetDeck.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/24.
//

// MARK: DO NOT USE. WIP.
// MARK: 使わないでﾈ

import Foundation
import WebKit

class TDBase {
    weak var webView: WKWebView?
}

final class TD: TDBase {
    static let shared = TD()

    public let account: AccountController = .init()
    public let settings: Settings = .init()
    public let actions: ActionsController = .init()

    override var webView: WKWebView? {
        get { super.webView }
        set(value) {
            super.webView = value

            account.webView = value
            settings.webView = value
            actions.webView = value
        }
    }

    class Settings: TDBase {}
    class AccountController: TDBase {}
    class ActionsController: TDBase {}
}
