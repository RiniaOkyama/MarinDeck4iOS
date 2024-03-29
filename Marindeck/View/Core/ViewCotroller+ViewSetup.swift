//
//  ViewCotroller+ViewSetup.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/08.
//

import UIKit
import WebKit

protocol ViewSetup {
    func setupView()
    func setupTweetBtn()
    func setupWebViewToolBar()
    //    func notchLogoSetup()
}

extension ViewController: ViewSetup {

    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        bottomBackView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        topBackView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        isBottomBackViewHidden = true
        imageView.center = view.center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill

        tweetFloatingBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tweetFloatingBtn.layer.shadowColor = UIColor.black.cgColor
        tweetFloatingBtn.layer.shadowOpacity = 0.3
        tweetFloatingBtn.layer.shadowRadius = 4
        tweetFloatingBtn.setImage(Asset.tweet.image)
        tweetFloatingBtn.tapped = tweetPressed

        setupTweetBtn()

        tweetFloatingBtn.isHidden = false

        mainDeckView.isHidden = true
        mainDeckView.backgroundColor = .none

        mainDeckBlurView = UIView(frame: CGRect(origin: .zero, size: view.bounds.size))
        mainDeckBlurView.backgroundColor = .none
        mainDeckBlurView.isUserInteractionEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onOrientationDidChange(notification:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)

        // FIXME
        menuVC = self.children[0] as? MenuViewController
        menuVC.delegate = self

        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()

        setupWebView()

        self.view.addSubview(mainDeckBlurView)

        setupWebViewToolBar()
    }

    func setupTweetBtn() {
        tweetFloatingBtn.removeAllActions()
        let arr = (userDefaults.array(forKey: UserDefaultsKey.actionButtoms) as? [String])?.prefix(3)
            ?? [ActionButtons.debug.rawValue, ActionButtons.gif.rawValue, ActionButtons.tweet.rawValue]
        for item in arr {
            let actionType = ActionButtons(rawValue: item)
            let action = NDTweetBtnAction(
                image: actionType?.getImage() ?? UIImage(),
                handler: { [unowned self] _ -> Void in
                    switch actionType {
                    case .debug:
                        self.openDebugModal()
                    case .gif:
                        self.openSelectGif()
                    case .tweet:
                        self.openWebViewTweetModal()
                    case .menu:
                        self.openMenu()
                    case .draft:
                        self.openDraft()
                    case .settings:
                        self.openSettings()
                    case .none:
                        break
                    }
                }
            )
            tweetFloatingBtn.addAction(action: action)
        }
    }

    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()

        let userContentController = WKUserContentController()

        userContentController.add(self, name: "general")

        webConfiguration.userContentController = userContentController
        webConfiguration.processPool = WKProcessPool.shared
        webConfiguration.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: mainDeckView.bounds, configuration: webConfiguration)

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
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
        td.webView = webView

        webView.translatesAutoresizingMaskIntoConstraints = false
        if userDefaults.bool(forKey: UserDefaultsKey.marginSafeArea) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }

    func setupWebViewToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let iconSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        iconSpaceItem.width = 8
        let gifItem = UIBarButtonItem(image: Asset.gif.image,
                                      style: .plain,
                                      target: self,
                                      action: #selector(openSelectGif))
        let photoItem = UIBarButtonItem(image: Asset.photo.image,
                                        style: .plain,
                                        target: self,
                                        action: #selector(openSelectPhoto))
        let scheduleItem = UIBarButtonItem(image: UIImage(systemName: "clock")?.withTintColor(.labelColor, renderingMode: .alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: #selector(presentDatePicker))

        gifItem.tintColor = .labelColor
        photoItem.tintColor = .labelColor
        doneItem.tintColor = .labelColor
        toolbar.backgroundColor = .backgroundColor
        toolbar.barTintColor = .backgroundColor
        toolbar.setItems([photoItem, iconSpaceItem, gifItem, iconSpaceItem, scheduleItem, flexibleSpaceItem, doneItem], animated: false)
        toolbar.sizeToFit()

        webView.addIndexAccessoryView(toolbar: toolbar)
    }
}
