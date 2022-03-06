//
//  Const.swift
//  Marindeck
//
//  Created by Rinia on 2021/04/12.
//

import Foundation
import UIKit
import LocalAuthentication

enum UserDefaultsKey: String, CaseIterable {
    case isDebugBtnHidden = "isDebugBtnHidden"
    case themeID = "themeID"
    case isUseBiometrics = "isUseBiometrics"
    case tweetButtonType = "tweetButtonType"
    case isOnBoarding = "isOnBoarding"
    case actionButtoms = "actionButtoms"
    case marginSafeArea = "marginSafeArea"
    case noSleep = "noSleep"
}

extension UserDefaults {
    func register(defaults: [UserDefaultsKey: Any]) {
        var registerValue: [String: Any] = [:]
        
        defaults.forEach({ (key, value) in
            registerValue[key.rawValue] = value
        })
        register(defaults: registerValue)
    }
    
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        self.set(value, forKey: key.rawValue)
    }
    
    func string(forKey defaultName: UserDefaultsKey) -> String? {
        string(forKey: defaultName.rawValue)
    }

    func array(forKey defaultName: UserDefaultsKey) -> [Any]? {
        array(forKey: defaultName.rawValue)
    }

    func dictionary(forKey defaultName: UserDefaultsKey) -> [String : Any]? {
        dictionary(forKey: defaultName.rawValue)
    }

    func data(forKey defaultName: UserDefaultsKey) -> Data? {
        data(forKey: defaultName.rawValue)
    }

    func stringArray(forKey defaultName: UserDefaultsKey) -> [String]? {
        stringArray(forKey: defaultName.rawValue)
    }

    func integer(forKey defaultName: UserDefaultsKey) -> Int {
        integer(forKey: defaultName.rawValue)
    }


    func float(forKey defaultName: UserDefaultsKey) -> Float {
        float(forKey: defaultName.rawValue)
    }


    func double(forKey defaultName: UserDefaultsKey) -> Double {
        double(forKey: defaultName.rawValue)
    }

    func bool(forKey defaultName: UserDefaultsKey) -> Bool {
        bool(forKey: defaultName.rawValue)
    }
}

struct EnvKeys {
    static let GIPHY_API_KEY = "GIPHY_API_KEY"
    static let DEPLOYGATE_SDK_API_KEY = "DEPLOYGATE_SDK_API_KEY"
    static let DEPLOYGATE_SDK_USERNAME = "DEPLOYGATE_SDK_USERNAME"
}

struct ActionItem {
    var title: String
    var icon: UIImage

}

enum ActionButtons: String {
    case debug = "debug", gif = "gif", tweet = "tweet", menu = "menu", draft = "draft", settings = "settings"

    func getImage() -> UIImage {
        switch self {
        case .debug:
            return UIImage(systemName: "ladybug")!
        case .gif:
            return Asset.gif.image.withRenderingMode(.alwaysTemplate)
        case .tweet:
            return Asset.tweet.image
        case .menu:
            return UIImage(systemName: "line.horizontal.3.decrease")!
        case .draft:
            return UIImage(systemName: "pencil.and.outline")!
        case .settings:
            return UIImage(systemName: "gearshape")!
        }
    }

    func getTitle() -> String {
        switch self {
        case .debug:
            return L10n.ActionButton.Debug.title
        case .gif:
            return L10n.ActionButton.Gif.title
        case .tweet:
            return L10n.ActionButton.Tweet.title
        case .menu:
            return L10n.ActionButton.Menu.title
        case .draft:
            return L10n.ActionButton.Draft.title
        case .settings:
            return L10n.ActionButton.Settings.title
        }
    }

    func getDescription() -> String {
        switch self {
        case .debug:
            return L10n.ActionButton.Debug.description
        case .gif:
            return L10n.ActionButton.Gif.description
        case .tweet:
            return L10n.ActionButton.Tweet.description
        case .menu:
            return L10n.ActionButton.Menu.description
        case .draft:
            return L10n.ActionButton.Draft.description
        case .settings:
            return L10n.ActionButton.Settings.description
        }
    }
}

enum TweetButtonType: String, CaseIterable {
    case `default` = "default"
    case native = "native"
    case twitterApp = "twitterApp"
    
    public var title: String {
        get {
            switch self {
            case .`default`:
                return "TweetDeck"
            case .native:
                return "ネイティブ"
            case .twitterApp:
                return "Twitter"
        }
    }
}
}

// Codable?
struct Theme {
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

    var lightTopBarColor: UIColor = #colorLiteral(red: 0.08278211206, green: 0.123489894, blue: 0.1700443327, alpha: 1)
    var darkTopBarColor: UIColor?
    var lightStatusBarColor: UIStatusBarStyle = .darkContent
    var darkStatusBarColor: UIStatusBarStyle = .lightContent
    var tweetButtonColor: UIColor = .init(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
}

let themes = [
    Theme(title: "デフォルト", id: "0", description: "TweetDeckデフォルトのテーマです。", user: "TweetDeck", icon: "", js: "", css: "",
          backgroundColor: UIColor(hex: "15202b"),
          secondaryBackgroundColor: UIColor(hex: "0d131a"),
          labelColor: .white,
          subLabelColor: .lightGray,
          lightTopBarColor: .white,
          darkTopBarColor: UIColor(hex: "15202b")
    ),
    Theme(title: "Midnight", id: "1", description: "Midra", user: "Midra", icon: "",
          js: getFile2Text("Theme-Midnight"), css: "",
          backgroundColor: .black,
          secondaryBackgroundColor: UIColor(hex: "242424"),
          labelColor: .white,
          subLabelColor: .lightGray,
          tweetButtonColor: UIColor(hex: "242424")
    ),
    Theme(title: "Wumpus", id: "2",
          description: "デスクトップ版Discordをモチーフにしたテーマです。明るすぎず暗すぎないDiscordのダークテーマが好きな方におすすめです",
          user: "hakunagi", icon: "", js: "", css: ""),

    Theme(title: "Frostclear", id: "3", user: "Midra", icon: "Frostclear-icon",
          js: getFile2Text("Theme-Frostclear"), css: "",
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
          lightTopBarColor: #colorLiteral(red: 0.8769347072, green: 0.4038944244, blue: 0.4008696377, alpha: 1),
          darkStatusBarColor: .darkContent,
          tweetButtonColor: UIColor(hex: "242424")
    )
]

func fetchTheme() -> Theme {
    let userDefaults = UserDefaults.standard
    if let themeID = userDefaults.string(forKey: .themeID) {
        return themes.filter({ $0.id == themeID })[0]
    } else {
        return themes[0]
    }
}

private func getFile2Text(_ forResource: String, ofType: String = "js") -> String {
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
    var error: NSError?

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
