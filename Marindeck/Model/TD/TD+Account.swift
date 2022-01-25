//
//  TD+Account.swift
//  Marindeck
//
//  Created by a on 2022/01/25.
//

extension TD.AccountController {
    
    struct Account {
        var name: String?
        var profileImageUrl: String?
        var userId: String?
        var username: String?
        // FIXME
//        var isPrivate: Bool?
//        var verified: Bool?
//        var updated: String?
//        var key: String?
    }

    func getAccount(completion: @escaping (_ account: Account) -> ()) {
        webView?.evaluateJavaScript("TD.storage.accountController.getDefault().state") {(obj, error) in
            guard let dict = obj as? [String: String] else { return }
            completion(Account(name: dict["name"], profileImageUrl: dict["profileImageURL"], userId: dict["username"], username: dict["username"]))
        }
    }
    
    
}

