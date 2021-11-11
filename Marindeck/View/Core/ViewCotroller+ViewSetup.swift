//
//  ViewCotroller+ViewSetup.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/08.
//

import UIKit
import WebKit

extension ViewController {

    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        bottomBackView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        topBackView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        isBottomBackViewHidden = true
        imageView.center = view.center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill

//        tweetFloatingBtn.layer.cornerRadius = tweetFloatingBtn.frame.width / 2
        tweetFloatingBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tweetFloatingBtn.layer.shadowColor = UIColor.black.cgColor
        tweetFloatingBtn.layer.shadowOpacity = 0.3
        tweetFloatingBtn.layer.shadowRadius = 4
//        tweetFloatingBtn.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        tweetFloatingBtn.setImage(Asset.tweet.image)
        tweetFloatingBtn.tapped = tweetPressed

        userDefaults.set(nil, forKey: UserDefaultsKey.actionButtoms)
        let arr = (userDefaults.array(forKey: UserDefaultsKey.actionButtoms) as? [String])?.prefix(3) ?? [ActionButtons.debug.rawValue, ActionButtons.gif.rawValue, ActionButtons.tweet.rawValue]
        for item in arr {
            let actionType = ActionButtons(rawValue: item)
            let action = NDTweetBtnAction(
                image: actionType?.getImage() ?? UIImage(),
                handler: { [unowned self] _ -> Void in
                    switch actionType {
                    case .debug:
                        self.debugPressed()
                    case .gif:
                        self.openSelectGif()
                    case .tweet:
                        self.openWebViewTweetModal()
                    case .menu:
                        self.openMenu()
                    case .draft:
                        break // TODO:
                    case .settings:
                        self.openSettings()
                    case .none:
                        break
                    }
                }
            )
            tweetFloatingBtn.addAction(action: action)
        }


//        let debugAction = NDTweetBtnAction(
//                image: UIImage(systemName: "ladybug")!,
//                handler: { (NDTweetBtnAction) -> Void in
//                    self.debugPressed()
//                })
//        let gifAction = NDTweetBtnAction(
//                image: Asset.gif.image.withRenderingMode(.alwaysTemplate),
//                handler: { (NDTweetBtnAction) -> Void in
//                    self.openSelectGif()
//                })
//        let tweetAction = NDTweetBtnAction(
//                image: Asset.tweet.image,
//                handler: { (NDTweetBtnAction) -> Void in
//                    self.openWebViewTweetModal()
//                })

//        tweetFloatingBtn.addAction(action: debugAction)
//        tweetFloatingBtn.addAction(action: gifAction)
//        tweetFloatingBtn.addAction(action: tweetAction)

        tweetFloatingBtn.isHidden = false // FIXME


        mainDeckView.backgroundColor = .none

        mainDeckBlurView = UIView(frame: CGRect(origin: .zero, size: view.bounds.size))
        mainDeckBlurView.backgroundColor = .none
        mainDeckBlurView.isUserInteractionEnabled = false

//        menuView.translatesAutoresizingMaskIntoConstraints = true
//        mainDeckView.translatesAutoresizingMaskIntoConstraints = true

        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationDidChange(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)

        // FIXME
        menuVC = self.children[0] as? MenuViewController
        menuVC.delegate = self

        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()


        setupWebView()

        self.view.addSubview(mainDeckBlurView)

        setupWebViewToolBar()
    }

    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()

        let userContentController = WKUserContentController()
        // FIXME: 循環参照の恐れアリ。
        JSCallbackFlag.allCases.forEach {
            userContentController.add(self, name: $0.rawValue)
        }


        webConfiguration.userContentController = userContentController
        webConfiguration.processPool = WKProcessPool.shared

//        mainDeckView.backgroundColor = .red
        webView = WKWebView(frame: mainDeckView.bounds, configuration: webConfiguration)

        // あほくさ
        webView.frame.size.width = view.frame.width
//        webView.frame.size.height = view.frame.height - (topBackView.frame.height + bottomBackView.frame.height)
//        webView.frame.origin.y = topBackView.frame.height

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
//        webView.scrollView.delegate = self

//        self.mainDeckView.addSubview(webView)
//        webView.anchorAll(equalTo: mainDeckView)
        webView.isOpaque = false
//        webView.allowsLinkPreview = false
//        webView.navigationDelegate = self

        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panTop))
        edgePan.edges = .left
        edgePan.delegate = self

        self.webView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        webView.addGestureRecognizer(edgePan)
        let interaction = UIContextMenuInteraction(delegate: self)
        webView.addInteraction(interaction)

        if DebugSettings.isWebViewLoad {
            let deckURL = URL(string: "https://tweetdeck.twitter.com")
//        let deckURL = URL(string: " https://mobile.twitter.com/login?hide_message=true&redirect_after_login=https://tweetdeck.twitter.com")

            var urlRequest = URLRequest(url: deckURL!)
            urlRequest.cachePolicy = .returnCacheDataElseLoad // https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy
            webView.load(urlRequest)
        }
        self.mainDeckView.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }

    func setupWebViewToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let iconSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        iconSpaceItem.width = 8
        let gifItem = UIBarButtonItem(image: Asset.gif.image, style: .plain, target: self, action: #selector(openSelectGif))
        let photoItem = UIBarButtonItem(image: Asset.photo.image, style: .plain, target: self, action: #selector(openSelectPhoto))

        gifItem.tintColor = .labelColor
        photoItem.tintColor = .labelColor
        doneItem.tintColor = .labelColor
        toolbar.backgroundColor = .backgroundColor
        toolbar.barTintColor = .backgroundColor
        toolbar.setItems([photoItem, iconSpaceItem, gifItem, flexibleSpaceItem, doneItem], animated: false)
        toolbar.sizeToFit()

        webView.addIndexAccessoryView(toolbar: toolbar)
    }

}
