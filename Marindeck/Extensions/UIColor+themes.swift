//
//  UIColor+themes.swift
//  Marindeck
//
//  Created by craptone on 2021/05/10.
//

import UIKit

fileprivate func getTheme() -> Theme{
    let userDefaults = UserDefaults.standard
    if let themeID = userDefaults.string(forKey: UserDefaultsKey.themeID){
        return themes.filter({ $0.id == themeID })[0]
    }else {
        return themes[0]
    }
}

extension UIColor{
    
    static var backgroundColor: UIColor { get { return getTheme().backgroundColor } }
    static var secondaryBackgroundColor: UIColor { get { return getTheme().secondaryBackgroundColor } }
    static var labelColor: UIColor { get { return getTheme().labelColor } }
    static var subLabelColor: UIColor { get { return getTheme().subLabelColor } }
    static var tweetButtonColor: UIColor { get { return getTheme().tweetButtonColor } }
    
    
    static func ldColor(light:UIColor,dark:UIColor) -> UIColor{
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                    dark:
                    light
                }
        }else{
            return light
        }
    }
}
