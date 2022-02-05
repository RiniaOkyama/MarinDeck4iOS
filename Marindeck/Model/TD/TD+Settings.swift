//
//  TD+Settings.swift
//  Marindeck
//
//  Created by a on 2022/01/25.
//

extension TD.Settings {
    
    enum Theme: String {
        case light = "light"
        case dark = "dark"
    }

    func getTheme(completion: @escaping (_ theme: Theme?) -> ()) {
        webView?.evaluateJavaScript("TD.settings.getTheme()") { value, error in
            completion(.init(rawValue: value as? String ?? ""))
        }
    }

    func setTheme(_ theme: Theme) {
        webView?.evaluateJavaScript("TD.settings.setTheme(\(theme.rawValue)", completionHandler: nil)
    }
}
