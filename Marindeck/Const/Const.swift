//
//  Const.swift
//  Marindeck
//
//  Created by craptone on 2021/04/12.
//

import Foundation
import UIKit
import LocalAuthentication

struct UserDefaultsKey {
    static let customJSs = "customJSs"
    static let isDebugBtnHidden = "isDebugBtnHidden"
    static let themeID = "themeID"
    static let isUseBiometrics = "isUseBiometrics"
    
    static let allKeys = [
        customJSs,
        isDebugBtnHidden,
        themeID,
        isUseBiometrics
    ]
}


struct EnvKeys {
    static let GIPHY_API_KEY = "GIPHY_API_KEY"
    static let DEPLOYGATE_SDK_API_KEY = "DEPLOYGATE_SDK_API_KEY"
    static let DEPLOYGATE_SDK_USERNAME = "DEPLOYGATE_SDK_USERNAME"
}

// Codable?
struct Theme{
    var title: String // テーマ名
    var id: String // かさらないように。一度変更したら変更しないでください。
    var description: String = "" // テーマの説明
    var user: String
    var icon: String // テーマのアイコンURL。アイコン作るセンスがなければ設定しないほうがいい。

    var js: String // テーマのJS。テーマに関係ないjsは含まないこと。
    var css: String // テーマのCSS。
    
//    var backgroundColor: String = UIColor.systemBackground.toHexString()
//    var secondaryBackgroundColor: String = UIColor.secondarySystemBackground.toHexString()
//    var labelColor: String = UIColor.label.toHexString()
//    var subLabelColor: String = UIColor.secondaryLabel.toHexString()
//    var tweetButtonColor: String = ""
    
    var backgroundColor: UIColor = .systemBackground
    var secondaryBackgroundColor: UIColor = .secondarySystemBackground
    var labelColor: UIColor = .label
    var subLabelColor: UIColor = .secondaryLabel
    
    var topBarColor: UIColor = #colorLiteral(red: 0.08278211206, green: 0.123489894, blue: 0.1700443327, alpha: 1)
    var statusBarColor: UIStatusBarStyle = .lightContent
    var tweetButtonColor: UIColor = UIColor(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
}

let themes = [
    Theme(title: "デフォルト", id: "0", description: "デフォルトでず。", user: "TweetDeck", icon: "", js: "", css: "",
          backgroundColor: UIColor(hex: "15202b"),
          secondaryBackgroundColor: UIColor(hex: "0d131a"),
          labelColor: .white,
          subLabelColor: .lightGray
      ),
    Theme(title: "Midnight", id: "1", description: "Midra", user: "Midra", icon: "", js: getFile2Text("Theme-Midnight"), css: "",
          backgroundColor: .black,
          secondaryBackgroundColor: UIColor(hex: "242424"),
          labelColor: .white,
          subLabelColor: .lightGray,
          tweetButtonColor: UIColor(hex: "242424")
    ),
    Theme(title: "Wumpus", id: "2",
          description: "デスクトップ版Discordをモチーフにしたテーマです。明るすぎず暗すぎないDiscordのダークテーマが好きな方におすすめです",
          user: "hakunagi", icon: "", js: "", css: ""),
    
    Theme(title: "Frostclear", id: "3", user: "Midra", icon: "Frostclear-icon", js: getFile2Text("Theme-Frostclear"), css: "",
          backgroundColor: UIColor(hex: "1a1a1a"),
          secondaryBackgroundColor: UIColor(hex: "242424"),
          labelColor: .white,
          subLabelColor: .lightGray,
          tweetButtonColor: UIColor(hex: "242424")
    ),
    
    Theme(title: "Dolce", id: "4",
          description: "デスクトップ版Discordをモチーフにしたテーマです。明るすぎず暗すぎないDiscordのダークテーマが好きな方におすすめです",
          user: "L1n4r1A a.k.a. るなち✿(人柱)",
          icon: "Dolce-icon",
          js: getFile2Text("Theme-Dolce_v2"), css: "",
          backgroundColor: #colorLiteral(red: 0.9286773205, green: 0.9065366387, blue: 0.831628263, alpha: 1),
          secondaryBackgroundColor: #colorLiteral(red: 0.9643818736, green: 0.9560024142, blue: 0.8829116225, alpha: 1),
          labelColor: UIColor(hex: "714116"),
          subLabelColor: UIColor(hex: "714116"),
          topBarColor: #colorLiteral(red: 0.8769347072, green: 0.4038944244, blue: 0.4008696377, alpha: 1),
          tweetButtonColor: UIColor(hex: "242424")
    ),
]

func fetchTheme() -> Theme{
    let userDefaults = UserDefaults.standard
    if let themeID = userDefaults.string(forKey: UserDefaultsKey.themeID){
        return themes.filter({ $0.id == themeID })[0]
    }else {
        return themes[0]
    }
}


fileprivate func getFile2Text(_ forResource: String, ofType: String = "js") -> String{
    if let filepath = Bundle.main.path(forResource: forResource, ofType: ofType) {
        do {
            let contents = try String(contentsOfFile: filepath)
            return contents
        } catch {
            print("\(forResource) load error")
            return ""
        }
    } else {
        print("\(forResource) not found!")
        return ""
    }
}


/// 生体認証が利用可能かどうか
func canUseBiometrics() -> Bool {

        let context = LAContext()
        var error: NSError? = nil

        let result = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

        guard !result else { return true }

        if let error = error {
            // iOS11以降とそれ以前ではErrorのコード名が異なるため、場合分け
            if #available(iOS 11.0, *) {
                switch error.code {
                case LAError.biometryNotEnrolled.rawValue, LAError.biometryLockout.rawValue:
                    return true
                default:
                    return false
                }
            } else {
                switch error.code {
                case LAError.touchIDNotEnrolled.rawValue, LAError.touchIDLockout.rawValue:
                    return true
                default:
                    return false
                }
            }
        }
        return false
    }

/// 生体認証を実行する
func doBiometricsAuthentication() {
    let context = LAContext()

    // 生体認証を使う理由。空文字だと失敗扱いになるので、必ず文字を入れる
    let reason = "ロックを解除"

    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluateError) in
        if success {
            print("Success!!")
        } else {
            guard let error = evaluateError as NSError? else {
                print("Error")
                return
            }
            print("\(error.code): \(error.localizedDescription)")
        }
    }
}
