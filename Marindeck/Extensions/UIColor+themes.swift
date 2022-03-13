//
//  UIColor+themes.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/10.
//

import UIKit

extension UIColor {

    static var backgroundColor: UIColor { get { fetchTheme().backgroundColor } }
    static var secondaryBackgroundColor: UIColor { get { fetchTheme().secondaryBackgroundColor } }
    static var labelColor: UIColor { get { fetchTheme().labelColor } }
    static var subLabelColor: UIColor { get { fetchTheme().subLabelColor } }
    static var tweetButtonColor: UIColor { get { fetchTheme().tweetButtonColor } }
    static var lightTopBarColor: UIColor { get { fetchTheme().lightTopBarColor } }
    static var darkTopBarColor: UIColor { get { fetchTheme().darkTopBarColor ?? fetchTheme().lightTopBarColor } }

    static func ldColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .dark ? dark: light
        }
    }
}
