//
//  TweetDeck.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/24.
//

// MARK: DO NOT USE. WIP.
// MARK: 使わないでﾈ

//import Foundation
//import WebKit
//
//
//class TDBase {
//    weak var webView: WKWebView?
//}
//
//final class TD: TDBase {
//    static let shared = TD()
//
////    public weak var webView: WKWebView?
//
//    private(set) var account: Account? = nil
//
//    //    private(set) let action: A
//    private(set) var settings: Settings? = nil
//
//
//
//
//    func update(completion: (() -> ())? = nil) {
//        webView?.evaluateJavaScript("TD.storage.accountController.getDefault().state") { [weak self] (obj, error) in
//            guard let dict = obj as? [String: String] else { return }
//            self?.account = Account(name: dict["name"], profileImageUrl: dict["profileImageURL"], userId: dict["username"], username: dict["username"])
//        }
//    }
//
//
//    struct Account {
//        var name: String?
//        var profileImageUrl: String?
//        var userId: String?
//        var username: String?
//    }
//
//    class Action {
//        fileprivate weak var webView: WKWebView?
//
//    }
//
//    class Settings: TDBase {}
//
//}
//
//extension TD.Settings {
//
//    var theme: Theme? {
//        set {
//            theme = newValue
//        }
//        get {
//            .dark
//        }
//    }
//
//    enum Theme: String {
//        case light = "light"
//        case dark = "dark"
//    }
//}
