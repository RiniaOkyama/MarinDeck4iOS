//
//  ViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/01/12.
//

import UIKit
import WebKit
import SafariServices

import Keys
import Optik

class ViewController: UIViewController, UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate, UIGestureRecognizerDelegate {
    var swipeStruct = {
        SwipeStruct()
    }()

    var contextMenuStruct = {
        ContextMenuStruct()
    }()

    var webView: WKWebView!
    public let td = TD.shared
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
    private(set) lazy var dbQueue = Database.shared.dbQueue
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
        [
            .init(title: L10n.ActionButton.Tweet.title, action: #selector(tweetPressed), input: "n", modifierFlags: [.command])
        ]
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

//        DGSLogv("%@", getVaList(["ViewDidLoad: DGLog test message"]))

        checkBiometrics()
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
        imageView.removeFromSuperview()
    }


//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//             scrollView.pinchGestureRecognizer?.isEnabled = false
//    }



    // ツイートボタンタップ痔の動作
    @objc func tweetPressed() {
        if userDefaults.bool(forKey: UserDefaultsKey.isNativeTweetModal) {
            openNativeTweetModal()
        } else {
            openWebViewTweetModal()
        }
    }
    
    // TweetDeckのツイートモーダルに遷移
    func openWebViewTweetModal() {
        webView.evaluateJavaScript("document.querySelector('.tweet-button.js-show-drawer:not(.is-hidden)').click()") { object, error in
            print("webViewLog : ", error ?? "成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.td.actions.focusTweetTextArea()
            }
        }
    }

    // FIXME: evaluteWithErrorは使用しない実装に変更
    // JS デバッグ
    @discardableResult
    func debugJS(script: String) -> (String, Error?) {
        let (ret, error) = webView.evaluateWithError(javaScript: script)
        return ((ret as? String) ?? "", error)
    }

    // CSSをjsに変換
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

    // CSS デバッグ
    func debugCSS(css: String) {
        let script = css2JS(css: css)
        webView.evaluateJavaScript(script) { object, error in
            print("stylecss : ", error ?? "成功")
        }
    }

    
    // 下書きを保存
    func saveDraft(text: String) {
        let df = Draft(id: nil, text: text)
        try! dbQueue.write{ db in
            try df.insert(db)
        }
    }

    // x, yに画像があれば取ってくる
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

    // Menuを閉じる
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

    // Menuを開く
    func openMenu() {
        isMenuOpen = true
        menuView.translatesAutoresizingMaskIntoConstraints = true
        mainDeckView.translatesAutoresizingMaskIntoConstraints = true
        mainDeckBlurView.isUserInteractionEnabled = true

        td.account.getAccount { [weak self] account in
            self?.menuVC.setUserIcon(url: account.profileImageUrl ?? "")
            self?.menuVC.setUserNameID(name: account.name ?? "", id: account.userId ?? "")
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.x = 0
            self.mainDeckBlurView.frame.origin.x = self.menuView.frame.width
            self.mainDeckView.frame.origin.x = self.menuView.frame.width

            UIView.animate(withDuration: 0.2, animations: {
                self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        })
    }

    // ブラーをつける（Menu開いたときのDeckのブラー）
    func setBlurView() {
        blurView.frame = view.frame
        view.addSubview(blurView)
    }

    // ブラーを消す（Menu開いたときのDeckのブラー）
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
            UIImage(url: $0)
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
    }
    
    
    func setPreviewImagePosition() {
        var y = Int(imagePreviewImagePositions[safe: imagePreviewSelectedIndex]?[safe: 1] ?? 0)
        if userDefaults.bool(forKey: UserDefaultsKey.marginSafeArea) {
            y += Int(view.safeAreaInsets.top)
        }
        imageView.frame = CGRect(
            x: Int(imagePreviewImagePositions[safe: imagePreviewSelectedIndex]?[safe: 0] ?? 0),
            y: y,
            width: Int(imagePreviewImagePositions[safe: imagePreviewSelectedIndex]?[safe: 2] ?? 0),
            height: Int(imagePreviewImagePositions[safe: imagePreviewSelectedIndex]?[safe: 3] ?? 0)
        )
    }
    
}
