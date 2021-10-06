//
//  UIColor+themes.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/10.
//

import UIKit

extension UIColor{
    
    static var backgroundColor: UIColor { get { return fetchTheme().backgroundColor } }
    static var secondaryBackgroundColor: UIColor { get { return fetchTheme().secondaryBackgroundColor } }
    static var labelColor: UIColor { get { return fetchTheme().labelColor } }
    static var subLabelColor: UIColor { get { return fetchTheme().subLabelColor } }
    static var tweetButtonColor: UIColor { get { return fetchTheme().tweetButtonColor } }
    static var topBarColor: UIColor { get { return fetchTheme().topBarColor } }
    
    
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
