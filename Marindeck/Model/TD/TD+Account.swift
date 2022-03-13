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

    func getAccount(completion: @escaping (_ account: Account) -> Void) {
        webView?.evaluateJavaScript("TD.storage.accountController.getDefault().state") {(obj, _) in
            guard let dict = obj as? [String: Any] else { return }
            completion(Account(name: dict["name"] as? String,
                               profileImageUrl: dict["profileImageURL"] as? String,
                               userId: dict["username"] as? String,
                               username: dict["username"] as? String))
        }
    }

}
