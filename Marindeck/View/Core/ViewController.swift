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

    @objc
    func onOrientationDidChange(notification: NSNotification) {
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

    @objc
    func dismissKeyboard() {
        webView.resignFirstResponder()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        imageView.removeFromSuperview()
    }

    // ツイートボタンタップ痔の動作
    @objc
    func tweetPressed() {
        if userDefaults.bool(forKey: UserDefaultsKey.isNativeTweetModal) {
            openNativeTweetModal()
        } else {
            openWebViewTweetModal()
        }
    }

    // 下書きを保存
    func saveDraft(text: String) {
        let df = Draft(id: nil, text: text)
        try! dbQueue.write { db in
            try df.insert(db)
        }
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
}

extension ViewController: LoginViewControllerOutput {
    func logined() {
        webView.reload()
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
