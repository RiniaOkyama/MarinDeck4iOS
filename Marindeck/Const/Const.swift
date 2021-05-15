//
//  Const.swift
//  Marindeck
//
//  Created by craptone on 2021/04/12.
//

import Foundation
import UIKit


struct UserDefaultsKey {
    static let customJSs = "customJSs"
    static let isDebugBtnHidden = "isDebugBtnHidden"
    static let themeID = "themeID"
}

struct EnvKeys {
    static let GIPHY_API_KEY = "GIPHY_API_KEY"
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
    Theme(title: "Wumpus", id: "2", description: "hakunagi", user: "hakunagi", icon: "", js: "", css: ""),
    
    Theme(title: "Frostclear", id: "3", user: "Midra", icon: "Frostclear-icon", js: getFile2Text("Theme-Frostclear"), css: "",
          backgroundColor: UIColor(hex: "1a1a1a"),
          secondaryBackgroundColor: UIColor(hex: "242424"),
          labelColor: .white,
          subLabelColor: .lightGray,
          tweetButtonColor: UIColor(hex: "242424")
    ),
    
    Theme(title: "Dolce", id: "4", user: "L1n4r1A a.k.a. るなち✿(人柱)",
          icon: "Dolce-icon",
          js: getFile2Text("Theme-Dolce_v2"), css: "",
          backgroundColor: #colorLiteral(red: 0.9286773205, green: 0.9065366387, blue: 0.831628263, alpha: 1),
          secondaryBackgroundColor: UIColor(hex: "242424"),
          labelColor: .white,
          subLabelColor: .lightGray,
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
