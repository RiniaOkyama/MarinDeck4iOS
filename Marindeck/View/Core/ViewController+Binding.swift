//
// Created by Rinia on 2021/07/16.
//


extension ViewController {
    // FIXME: あとから出てきたheaderに適用されない。
    func setStatusBarSpace(height: Int) {
        let headerHeight = height + 50
        webView.evaluateJavaScript("""
                                   document.querySelectorAll(".column-header").forEach(function(item) {
                                       item.style.height = "\(headerHeight)px"
                                       item.style.maxHeight = "\(headerHeight)px"
                                       item.style.paddingTop = "\(height)px"
                                   })
                                   """) { _, error in
            print(#function, error ?? "成功")
        }
        webView.evaluateJavaScript("""
                                   document.querySelectorAll(".js-detail-header").forEach(function(item) {
                                       item.style.height = "\(headerHeight)px"
                                       item.style.maxHeight = "\(headerHeight)px"
                                       item.style.paddingTop = "\(height)px"
                                   })
                                   """) { _, error in
            print(#function, error ?? "成功")
        }
    }
    
    func getTheme(completion: @escaping (_ theme: TD.Settings.Theme?) -> ()) {
        webView.evaluateJavaScript("TD.settings.getTheme()") { value, error in
            completion(.init(rawValue: value as? String ?? ""))
        }
    }
    
    func setTheme(theme: TD.Settings.Theme) {
        webView.evaluateJavaScript("TD.settings.setTheme(\(theme.rawValue)", completionHandler: nil)
    }

}
