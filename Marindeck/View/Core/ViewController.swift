//
//  ViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/01/12.
//

import UIKit
import WebKit
import SafariServices
import LocalAuthentication

import Keys
import Optik
import GiphyUISDK
import SwiftUI


class ViewController: UIViewController, UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate, UIGestureRecognizerDelegate {
    var swipeStruct = {
        SwipeStruct()
    }()

    var contextMenuStruct = {
        ContextMenuStruct()
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
    var notchLogoImageView: UIImageView!

    var isMenuOpen = false
    let userDefaults = UserDefaults.standard
    private lazy var dbQueue = Database.shared.dbQueue
    var isMainDeckViewLock = false
    var picker: UIImagePickerController! = UIImagePickerController()

    var imagePreviewSelectedIndex = 0
    var imagePreviewImageStrings: [String] = []
    var imagePreviewImagePositions: [[Float]] = []

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
            } else {
                bottomBackView.isHidden = false
                bottomBackViewConstraint.constant = 50
            }
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            .init(title: L10n.ActionButton.Tweet.title, action: #selector(self.tweetPressed), input: "n", modifierFlags: [.command])
        ]
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

//        DGSLogv("%@", getVaList(["ViewDidLoad: DGLog test message"]))

        checkBiometrics()

        Giphy.configure(apiKey: MarindeckKeys().giphyApiKey)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
        webView.frame = mainDeckView.bounds
        setupTweetBtn()
        
        if !userDefaults.bool(forKey: UserDefaultsKey.isOnBoarding) {
            let onBoardingVC = OnBoardingViewController()
            onBoardingVC.modalPresentationStyle = .currentContext
            present(onBoardingVC, animated: false, completion: nil)
        }
    }

    func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith
            otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    @objc func onOrientationDidChange(notification: NSNotification) {
        // FIXME
        mainDeckView.bounds = view.bounds
        webView.frame = mainDeckView.bounds
        mainDeckBlurView.frame.size = view.bounds.size
    }

    override var canBecomeFirstResponder: Bool {
        get {
            true
        }
    }


    // MARK: StatusbarColor
    private (set) var statusBarStyle: UIStatusBarStyle = .default

    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }


    @objc func dismissKeyboard() {
        webView.resignFirstResponder()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidDismiss!!!!!!!!!!!!!!")
        imageView.removeFromSuperview()
    }


//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//             scrollView.pinchGestureRecognizer?.isEnabled = false
//    }

    func checkBiometrics() {
        let isUseBiometrics = UserDefaults.standard.bool(forKey: UserDefaultsKey.isUseBiometrics)
        if isUseBiometrics {
            if canUseBiometrics() {
                isMainDeckViewLock = true
                mainDeckView.isHidden = true
                let context = LAContext()
                let reason = "ロックを解除"
                let backBlackView = UIView(frame: view.bounds)
                backBlackView.backgroundColor = .black
                view.addSubview(backBlackView)
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluateError) in
                    if success {
                        DispatchQueue.main.async { [unowned self] in
                            self.isMainDeckViewLock = false
                            self.mainDeckView.isHidden = false
                            self.tweetFloatingBtn.isHidden = false
                            UIView.animate(withDuration: 0.3, animations: {
                                backBlackView.alpha = 0
                            }, completion: { _ in
                                backBlackView.removeFromSuperview()
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            let errorLabel = UILabel(frame: backBlackView.bounds)
                            errorLabel.textAlignment = .center
                            errorLabel.text = "認証に失敗しました。"
                            errorLabel.textColor = .white
                            backBlackView.addSubview(errorLabel)
                        }
                        guard let error = evaluateError as NSError? else {
                            print("Error")
                            return
                        }
                        print("\(error.code): \(error.localizedDescription)")
                    }
                }
            } else {
                // 生体認証をオンにしているが、許可されていない。
            }
        }
    }


    func loadCSSFile(forResource: String, ofType: String = "css") {
        guard let mtPath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
            print("failed load style.css")
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
        webView.evaluateJavaScript(script) { object, error in
            print("stylecss : ", error ?? "成功")
        }
    }


    func loadJsFile(forResource: String, ofType: String = "js") {
        guard let mtPath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
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
        if userDefaults.bool(forKey: UserDefaultsKey.isNativeTweetModal) {
            openNativeTweetModal()
        } else {
            openWebViewTweetModal()
        }
    }
    
    
    func openWebViewTweetModal() {
        webView.evaluateJavaScript("document.querySelector('.tweet-button.js-show-drawer:not(.is-hidden)').click()") { object, error in
            print("webViewLog : ", error ?? "成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusTweetTextArea()
            }
        }
    }

    @objc func debugPressed() {
        let vc = DebugerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    @discardableResult
    func debugJS(script: String) -> (String, Error?) {
        let (ret, error) = webView.evaluateWithError(javaScript: script)
        return ((ret as? String) ?? "", error)
    }

    func css2JS(css: String) -> String {
        var deletecomment = css.replacingOccurrences(of: "[\\s\\t]*/\\*/?(\\n|[^/]|[^*]/)*\\*/", with: "")
        deletecomment = deletecomment.replacingOccurrences(of: "\"", with: "\\\"")
        deletecomment = deletecomment.replacingOccurrences(of: "\n", with: "\\\n")
        let script = """
                     (() => {
                     const h = document.documentElement;
                     const s = document.createElement('style');
                     s.insertAdjacentHTML('beforeend', "\(deletecomment)");
                     h.insertAdjacentElement('beforeend', s);
                     })();
                     """
        return script
    }

    func debugCSS(css: String) {
        let script = css2JS(css: css)
        webView.evaluateJavaScript(script) { object, error in
            print("stylecss : ", error ?? "成功")
        }
    }

    @objc func openSelectGif() {
        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 0.7
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

    // ネイティブのツイートモーダルを表示
    func openNativeTweetModal(tweetText: String = "") {
        let alert = UIAlertController(
                title: "Tweet Faster",
                message: "What's Happening!?",
                preferredStyle: .alert)
        alert.addTextField(
                configurationHandler: {_ in }
        )
        alert.textFields?[0].text = tweetText
        alert.addAction(
                UIAlertAction(
                        title: "Cancel",
                        style: UIAlertAction.Style.cancel) { [weak self] _ in
                    let text = alert.textFields![0].text!
                    if text == "" { return }
                    self?.openIfDraftAlert(text: text)
                }
        )
        alert.addAction(
                UIAlertAction(
                        title: "Tweet",
                        style: UIAlertAction.Style.default) { [weak self] _ in
                    self?.tweet(text: alert.textFields![0].text!)
                }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func openIfDraftAlert(text: String) {
        let alert = UIAlertController(title: "下書きに保存しますか？", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            self?.saveDraft(text: text)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // 下書きを保存
    func saveDraft(text: String) {
        let df = Draft(id: nil, text: text)
        try! dbQueue.write{ db in
            try df.insert(db)
        }
    }
    

    func openDraft() {
        let drafts = try! dbQueue.read { db in
            try Draft.fetchAll(db)
        }
        let vc = UIHostingController(rootView: DraftView(selected: { [weak self] index in
            self?.openNativeTweetModal(tweetText: drafts[index].text)
            
            let _ = try! self?.dbQueue.write { db in
                try drafts[index].delete(db)
            }
        }, drafts: drafts))
        present(vc, animated: true, completion: nil)
    }


    func getPositionElements(x: Int, y: Int) -> (Int, [String]) {
        guard let value = webView.evaluate(javaScript: "positionElement(\(x), \(y))") else {
            return (0, [])
        }
        let valueStrings = value as! [Any]
        let index = valueStrings[0] as! Int
        let urls = valueStrings[1] as! [String]

        let imgUrls = urls.map({
            url2NomalImg($0)
        })
        print("getPositionElements", index, imgUrls)

        return (index, imgUrls)
    }


    func closeMenu() {
        isMenuOpen = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        mainDeckView.translatesAutoresizingMaskIntoConstraints = false
        mainDeckBlurView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.mainDeckBlurView.backgroundColor = .none

            self.mainDeckBlurView.frame.origin.x = 0
            self.mainDeckView.frame.origin.x = 0
            self.bottomBackView.frame.origin.x = 0
            self.topBackView.frame.origin.x = 0

            self.menuView.frame.origin.x = -self.menuView.frame.width
        })
    }
    
    func openMenu() {
        isMenuOpen = true
        menuView.translatesAutoresizingMaskIntoConstraints = true
        mainDeckView.translatesAutoresizingMaskIntoConstraints = true
        mainDeckBlurView.isUserInteractionEnabled = true

        menuVC.setUserIcon(url: getUserIcon())
        let (name, id) = getUserNameID()
        menuVC.setUserNameID(name: name, id: id)

        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.x = 0
            self.mainDeckBlurView.frame.origin.x = self.menuView.frame.width
            self.mainDeckView.frame.origin.x = self.menuView.frame.width

            UIView.animate(withDuration: 0.2, animations: {
                self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        })
    }

    func setBlurView() {
        blurView.frame = view.frame
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
        if let index = r.range(of: "&name")?.lowerBound {
            r = String(r[...index]) // + "name=orig"
            return r.replacingOccurrences(of: "format=jpg", with: "format=png")
        }
        return ""
    }


    func imagePreviewer(index: Int, urls: [String]) {
        imagePreviewSelectedIndex = index
        
        let imgUrls = urls.map({
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

        let imgs = imgUrls.compactMap({
            url2UIImage(url: $0)
        })

        if imgs.isEmpty {
            return
        }

        let imageViewer = Optik.imageViewer(
                withImages: imgs,
                initialImageDisplayIndex: imagePreviewSelectedIndex,
                delegate: self
        )

        imageView.image = imgs[imagePreviewSelectedIndex]
        setPreviewImagePosition()
        view.addSubview(imageView)
//            imageViewer.presentationController?.delegate = self
        present(imageViewer, animated: true, completion: nil)
    }

}


extension ViewController: LoginViewControllerOutput {
    func logined() {
        webView.reload()
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

        if ((url?.absoluteString.contains("twitter.com/i/cards")) ?? false) ||
            (url?.absoluteString.contains("youtube.com/embed") ?? false)
        {
            decisionHandler(.cancel)
            return
        }
        
        if host == "tweetdeck.twitter.com" {
            decisionHandler(.allow)
//        }else if host.hasPrefix("t.co") {
//            decisionHandler(.cancel)
        } else if host == "mobile.twitter.com" {
            let vc = LoginViewController()
            vc.delegate = self
            let nvc = UINavigationController(rootViewController: vc)
            present(nvc, animated: true, completion: nil)
            decisionHandler(.cancel)
        }else {
            let safariVC = SFSafariViewController(url: url!)
            present(safariVC, animated: true, completion: nil)

            decisionHandler(.cancel)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadJsFile(forResource: "moduleraid")
//        loadJsFile(forResource: "marindeck-css")
        loadJsFile(forResource: "msecdeck.bundle")
        loadJsFile(forResource: "marindeck")
        loadCSSFile(forResource: "marindeck")

        let cjss = try! dbQueue.read { db in
            try CustomJS.fetchAll(db)
        }
            .filter { $0.isLoad }
            .sorted(by: { $0.loadIndex < $1.loadIndex })
        for item in cjss {
            debugJS(script: item.js)
        }

        let csss = try! dbQueue.read { db in
            try CustomCSS.fetchAll(db)
        }
            .filter { $0.isLoad }
            .sorted(by: { $0.loadIndex < $1.loadIndex })
        for item in csss {
            debugCSS(css: item.css)
        }


        let theme = fetchTheme()
        debugJS(script: theme.js)

    }

}

extension ViewController: MenuDelegate {
    func reload() {
        webView.reload()
        closeMenu()
    }

    func openProfile() {
        closeMenu()
        webView.evaluateJavaScript("document.querySelector(\"body > div.application.js-app.is-condensed > header > div > div.js-account-summary > a > div\").click()") { object, error in
            print("openProfile : ", error ?? "成功")
        }
    }

    func openColumnAdd() {
        closeMenu()
        webView.evaluateJavaScript("document.querySelector(\".js-header-add-column\").click()") { object, error in
            print(#function, error ?? "成功")
        }
    }
}

extension ViewController: ImageViewerDelegate {

    func transitionImageView(for index: Int) -> UIImageView {
        imageView!
    }

    func imageViewerDidDisplayImage(at index: Int) {
        imagePreviewSelectedIndex = index
        setPreviewImagePosition()
        print("imageVIewerDidDisplafmeifimageeee")
    }
    
    
    func setPreviewImagePosition() {
        var y = Int(imagePreviewImagePositions[safe: imagePreviewSelectedIndex]?[safe: 1] ?? 0)
        if userDefaults.bool(forKey: UserDefaultsKey.marginSafeArea) {
            y += Int(view.safeAreaInsets.top)
        }
        imageView.frame = CGRect(
            x: Int(imagePreviewImagePositions[imagePreviewSelectedIndex][0]),
            y: y,
            width: Int(imagePreviewImagePositions[imagePreviewSelectedIndex][2]),
            height: Int(imagePreviewImagePositions[imagePreviewSelectedIndex][3])
        )
    }
    
}


// FIXME
func url2UIImage(url: String) -> UIImage? {
    let url = URL(string: url)
    if url == nil {
        return nil
    }
    do {
        let data = try Data(contentsOf: url!)
        return UIImage(data: data)
    } catch let err {
        print("Error : \(err.localizedDescription)")
    }
    return nil
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
                let url: URL = URL(string: media.url(rendition: .original, fileType: .gif)!)!
                //Now use image to create into NSData format
                let imageData: NSData = NSData.init(contentsOf: url)!
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("\(info)")
        if let image = info[.originalImage] as? UIImage {
            guard let base64img = image.pngData()?.base64EncodedString(options: []) else {
                return
            }
            webView.evaluateJavaScript("addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { object, error in
                print("photoselected : ", error ?? "成功")
            }
            dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            guard let base64img = image.pngData()?.base64EncodedString(options: []) else {
                return
            }
            webView.evaluateJavaScript("addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { object, error in
                print("photoselected : ", error ?? "成功")
            }
        } else {
            print("Error")
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
