//
//  ViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/01/12.
//

import UIKit
import WebKit
import SafariServices

import Optik
import GiphyUISDK

#if DEBUG
import FLEX
#endif


class ViewController: UIViewController, UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate, UIGestureRecognizerDelegate {
    var swipeStruct = {
        return SwipeStruct()
    }()
    
    var webView: WKWebView!
    public var javaScriptString = ""
    @IBOutlet weak var mainDeckView: UIView!
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var bottomBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBackView: UIView!
    @IBOutlet weak var tweetFloatingBtn: NDTweetBtn!
    
    @IBOutlet weak var menuView: UIView!
    var menuVC: MenuViewController!

    let imageView: UIImageView! = UIImageView()
    let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .systemMaterialDark)
        return blurView
    }()
    var mainDeckBlurView: UIView!
    
    var isMenuOpen = false
    private let userDefaults = UserDefaults.standard
    private let env = ProcessInfo.processInfo.environment
    var picker: UIImagePickerController! = UIImagePickerController()

    var imagePreviewSelectedIndex = 0
    var imagePreviewImageStrings: [String] = []

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.style = .medium
        return ActivityIndicator
    }()
    
    var isBottomBackViewHidden = false {
        didSet {
            if isBottomBackViewHidden {
                bottomBackView.isHidden = true
                bottomBackViewConstraint.constant = 0
            }else {
                bottomBackView.isHidden = false
                bottomBackViewConstraint.constant = 50
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        DGSLogv("%@", getVaList(["ViewDidLoad: DGLog test message"]))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        webView.frame = mainDeckView.bounds
        #if DEBUG
            FLEXManager.shared.showExplorer()
        #endif
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
        return true
    }

    @objc func onOrientationDidChange(notification: NSNotification) {
        // FIXME
        mainDeckView.bounds = view.bounds
        webView.frame = mainDeckView.bounds
        mainDeckBlurView.frame.size = view.bounds.size
    }
    
    override var canBecomeFirstResponder: Bool {
        get { return true }
    }
    
    
    // MARK: StatusbarColor
    private (set) var statusBarStyle: UIStatusBarStyle = .default
    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    
    @objc func dismissKeyboard() {
        webView.resignFirstResponder()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidDismiss!!!!!!!!!!!!!!")
        self.imageView.removeFromSuperview()
    }


//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//             scrollView.pinchGestureRecognizer?.isEnabled = false
//    }
    
    
    func loadCSSFile(forResource: String, ofType:String = "css"){
        guard let mtPath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
            print("faild load style.css")
            return
        }
        let mtFile = FileHandle(forReadingAtPath: mtPath)!
        let mtContentData = mtFile.readDataToEndOfFile()
        let css = String(data: mtContentData, encoding: .utf8)!
        mtFile.closeFile()
        var deletecomment = css.replacingOccurrences(of: "[\\s\\t]*/\\*/?(\\n|[^/]|[^*]/)*\\*/", with: "")
        deletecomment = deletecomment.replacingOccurrences(of: "\"", with: "\\\"")
        deletecomment = deletecomment.replacingOccurrences(of: "\n", with: "\\\n")
        let script = """
const h = document.documentElement;
const s = document.createElement('style');
s.insertAdjacentHTML('beforeend', "\(deletecomment)");
h.insertAdjacentElement('beforeend', s)
"""
        webView.evaluateJavaScript(script){ object, error in
            print("stylecss : ", error ?? "成功")
        }
    }

    
    func loadJsFile(forResource: String, ofType:String = "js"){
        guard let mtPath = Bundle.main.path(forResource:forResource, ofType:ofType) else {
            print("ERROR")
            return
        }
        let mtFile = FileHandle(forReadingAtPath: mtPath)!
        let mtContentData = mtFile.readDataToEndOfFile()
        let mtContentString = String(data: mtContentData, encoding: .utf8)!
        mtFile.closeFile()

        let mtScript = mtContentString
        webView.evaluateJavaScript(mtScript) { object, error in
            print("webViewLog : ", error ?? "成功")
        }
    }
    

    @objc func tweetPressed() {
        webView.evaluateJavaScript("document.querySelector('.tweet-button.js-show-drawer:not(.is-hidden)').click()") { object, error in
            print("webViewLog : ", error ?? "成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.focusTweetTextArea()
            }
        }
    }

    @objc func debugPressed() {
        let vc = DebugerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func debugJS(script: String) -> (String, Error?) {
        let (ret, error) = webView.evaluateWithError(javaScript: script)
//        print(ret, error)
        return ((ret as? String) ?? "", error)
    }
    
    @objc func openSelectGif() {
        let giphy = GiphyViewController()
        Giphy.configure(apiKey: env[EnvKeys.GIPHY_API_KEY] ?? "")
//        giphy.theme = GPHTheme(type: settingsViewController.theme)
//        giphy.mediaTypeConfig = settingsViewController.mediaTypeConfig
        GiphyViewController.trayHeightMultiplier = 0.7
//        giphy.showConfirmationScreen = settingsViewController.confirmationScreen == .on
        giphy.shouldLocalizeSearch = true
        giphy.delegate = self
        giphy.dimBackground = true
        giphy.modalPresentationStyle = .overCurrentContext

        present(giphy, animated: true, completion: nil)
    }
    
    @objc func openSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func openSettings() {
//        self.performSegue(withIdentifier: "toSettings", sender: nil)
        let vc = storyboard?.instantiateViewController(identifier: "Settings") as! SettingsTableViewController
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getUserIcon() -> String{
        return (webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app.is-condensed > header > div > div.js-account-summary > a > div > img').src") as? String) ?? "https://pbs.twimg.com/media/Ewk-ESrUYAAZYKe?format=jpg&name=medium"
    }
    
    func getUserNameID() -> (String, String) {
        let userName = webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app > header > div > div.js-account-summary > a > div > div > div > span').innerText") as? String ?? "unknown"
        let userID = webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app > header > div > div.js-account-summary > a > div > div > span').innerText") as? String ?? "@unknown"
        return (userName, userID)
    }
    
    func isColumnScroll(_ bool: Bool) {
        let isScroll = bool ? "on" : "off"
        webView.evaluateJavaScript("columnScroll.\(isScroll)()") { object, error in
            print("webViewLog : ", error ?? "成功")
        }
    }
    
    // MARK: Menu open
    @objc func panTop(sender: UIScreenEdgePanGestureRecognizer) {
        let move:CGPoint = sender.translation(in: view)
        
        if self.menuView.frame.origin.x > 0 && 0 < move.x{
            
        }else{
            mainDeckView.center.x += move.x
            mainDeckBlurView.center.x += move.x
            self.menuView.center.x += move.x
        }
        
        self.view.layoutIfNeeded()
        
        if (sender.state == .began){
            print("began")
//            isColumnScroll(false)
            menuView.translatesAutoresizingMaskIntoConstraints = false
            mainDeckView.translatesAutoresizingMaskIntoConstraints = false
            
            mainDeckBlurView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
            
            menuVC.setUserIcon(url: getUserIcon())
            let (name, id) = getUserNameID()
            menuVC.setUserNameID(name: name, id: id)
        }
        
        else if(sender.state == .ended || sender.state == .cancelled || sender.state == .failed) {
            print("cancel or end or fail")
//            isColumnScroll(true)
            menuView.translatesAutoresizingMaskIntoConstraints = true
            mainDeckView.translatesAutoresizingMaskIntoConstraints = true
            
            if mainDeckView.frame.origin.x > self.menuView.frame.width / 2{
                isMenuOpen = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.menuView.frame.origin.x = 0
                    self.mainDeckBlurView.frame.origin.x = self.menuView.frame.width
                    self.mainDeckView.frame.origin.x = self.menuView.frame.width
                })
            }else{
                mainDeckBlurView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.mainDeckBlurView.backgroundColor = .none
//                    self.topBackBlurView.backgroundColor = .none
//                    self.bottomBackBlurView.backgroundColor = .none
                    
                    self.mainDeckBlurView.frame.origin.x = 0
                    self.mainDeckView.frame.origin.x = 0
                    self.bottomBackView.frame.origin.x = 0
                    self.topBackView.frame.origin.x = 0
                    
                    self.menuView.frame.origin.x = -self.menuView.frame.width
                })
            }
        }
        // reset
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func positionTweetLike(x: Int, y: Int) {
        webView.evaluateJavaScript("touchPointTweetLike(\(x), \(y))", completionHandler: { object, error in
            print("touchPointTweetLike : ", error ?? "成功")
        })
    }
    
    func getPositionElements(x: Int, y: Int) -> (Int, [String]) {
        print("position", x, y)
        guard let value = webView.evaluate(javaScript: "positionElement(\(x), \(y))") else {
            return (0, [])
        }
        let valueStrings = value as! [Any]
        let index = valueStrings[0] as! Int
        let urls = valueStrings[1] as! [String]

//        var imgUrls: [String] = []
//        for url in urls {
//            if let imgurl = url2NomalImg(url) {
//                imgUrls.append(imgurl)
//
//            }
//        }
        let imgUrls = urls.map({
            url2NomalImg($0)
        })

        print("getPositionElements", index, imgUrls)

        return (index, imgUrls)
    }
    
    func focusTweetTextArea() {
        webView.evaluateJavaScript("document.querySelector(\"body > div.application.js-app.is-condensed.hide-detail-view-inline > div.js-app-content.app-content.is-open > div:nth-child(1) > div > div > div > div > div > div.position-rel.compose-text-container.padding-a--10.br--4 > textarea\").focus()") { object, error in
            print("focusTweetTextArea : ", error ?? "成功")
        }
    }
    
    func closeMenu() {
        isMenuOpen = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        mainDeckView.translatesAutoresizingMaskIntoConstraints = false
        mainDeckBlurView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.mainDeckBlurView.backgroundColor = .none
          
            self.mainDeckBlurView.frame.origin.x = 0
            self.mainDeckView.frame.origin.x = 0
            self.bottomBackView.frame.origin.x = 0
            self.topBackView.frame.origin.x = 0
            
            self.menuView.frame.origin.x = -self.menuView.frame.width
        })
    }
    
    func setBlurView() {
        blurView.frame = self.view.frame
        view.addSubview(blurView)
    }

    func removeBlurView() {
        blurView.removeFromSuperview()
    }

    func dismissfetcher(animated: Any, completion: Any) {
        imageView.removeFromSuperview()
    }

    func url2SmallImg(_ str: String) -> String {
        var r = str.replacingOccurrences(of: "url(\"", with: "")
        r = r.replacingOccurrences(of: "\")", with: "")
        return r
    }

    func url2NomalImg(_ str: String) -> String {
        var r = url2SmallImg(str)
        if let index = r.range(of: "&name")?.lowerBound{
            r = String(r[...index]) // + "name=orig"
            return r
        }
        return ""
    }
    

    func fetchCustomJSs() -> [CustomJS] {
        let jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        var retArray: [CustomJS] = []
        for item in jsonArray {
            let jsonData = item.data(using: .utf8)!
            retArray.append(try! JSONDecoder().decode(CustomJS.self, from: jsonData))
        }
        return retArray
    }
    
    func imagePreviewer(index: Int, urls: [String]) {
        print("imagePreviewer index: \(index), url: \(urls)")

//        var imgUrls: [String] = []
//        for url in urls {
//            if let imgurl = url2NomalImg(url) {
//                imgUrls.append(imgurl)
//
//            }
//        }
        var imgUrls = urls.map({
            url2NomalImg($0)
        })
        
        print("parsed", imgUrls)
        
        if imgUrls.count == 0 {
            return
        }
        if imgUrls[0] == "" {
            print("imgUrl is nil")
            return
        }

        let imgs = imgUrls.map({
            url2UIImage(url: $0)
        })

        print("loaded!")
//            let imgsURL = imgUrls.map({
//                URL(string: $0)!
//            })
        let imageDownloader = AlamofireImageDownloader()
        let imageViewer = Optik.imageViewer(
                withImages: imgs,
                initialImageDisplayIndex: index,
                delegate: self
        )
//            let imageDownloader = AlamofireImageDownloader()
//            let imageViewer = Optik.imageViewer(
//                withURLs: imgsURL,
//                imageDownloader: imageDownloader
////                delegate: self
//            )

        imageView.image = imgs[index]
        self.view.addSubview(imageView)
//            imageViewer.presentationController?.delegate = self
        present(imageViewer, animated: true, completion: nil)


    }

}


// MARK: - 11 WKWebView WKNavigation delegate
extension ViewController: WKNavigationDelegate {
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        guard let host = url?.host else {
            decisionHandler(.cancel)
            return
        }
        if host == "tweetdeck.twitter.com" || host == "mobile.twitter.com" {
            decisionHandler(.allow)
//        }else if host.hasPrefix("t.co") {
//            decisionHandler(.cancel)
        }else{
            let safariVC = SFSafariViewController(url: url!)
            present(safariVC, animated: true, completion: nil)
            
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        loadJsFile(forResource: "mtdeck")
        loadJsFile(forResource: "moduleraid")
        loadJsFile(forResource: "marindeck-css")
        loadJsFile(forResource: "marindeck")
        loadCSSFile(forResource: "marindeck")
        
        let cjss = fetchCustomJSs()
        for item in cjss {
            debugJS(script: item.js)
        }
        
        let theme = fetchTheme()
        debugJS(script: theme.js)
        
    }

    public func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        let vc = UIViewController()
        return vc
    }
    
}

extension ViewController: MenuDelegate {
    func reload() {
        webView.reload()
    }
    
    func openProfile() {
        self.closeMenu()
        webView.evaluateJavaScript("document.querySelector(\"body > div.application.js-app.is-condensed > header > div > div.js-account-summary > a > div\").click()") { object, error in
            print("openProfile : ", error ?? "成功")
        }
    }
}

extension ViewController: ImageViewerDelegate {

    func transitionImageView(for index: Int) -> UIImageView {
        return imageView!
    }

    func imageViewerDidDisplayImage(at index: Int) {
//        currentLocalImageIndex = index
        print("imageVIewerDidDisplafmeifimageeee")
    }

}


// FIXME
func url2UIImage(url: String) -> UIImage {
    let url = URL(string: url)
    if url == nil {
        return UIImage()
    }
    do {
        let data = try Data(contentsOf: url!)
        return UIImage(data: data)!
    } catch let err {
        print("Error : \(err.localizedDescription)")
    }
    return UIImage()
}


extension ViewController: GiphyDelegate {
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
//            print(media.url(rendition: .original, fileType: .gif))
            self?.loadingIndicator.startAnimating()
            self?.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            DispatchQueue(label: "tweetgifload.async").async {
                let url:URL = URL(string: media.url(rendition: .original, fileType: .gif)!)!
                //Now use image to create into NSData format
                let imageData:NSData = NSData.init(contentsOf: url)!
                let data = imageData.base64EncodedString(options: [])
                DispatchQueue.main.sync {
                    self?.webView.evaluateJavaScript("addTweetImage(\"data:image/gif;base64,\(data)\", \"image/gif\", \"test.gif\")") { object, error in
                        print("gifLoad : ", error ?? "成功")
                        self?.loadingIndicator.stopAnimating()
                        self?.mainDeckBlurView.backgroundColor = .clear
                    }
                }
            }
        })
        GPHCache.shared.clear()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        GPHCache.shared.clear()
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        if let image = info[.originalImage] as? UIImage {
            guard let base64img = image.pngData()?.base64EncodedString(options: []) else { return }
            self.webView.evaluateJavaScript("addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { object, error in
                print("photoselected : ", error ?? "成功")
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            guard let base64img = image.pngData()?.base64EncodedString(options: []) else { return }
            self.webView.evaluateJavaScript("addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { object, error in
                print("photoselected : ", error ?? "成功")
            }
        } else{
            print("Error")
        }

        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
