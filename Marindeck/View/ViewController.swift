//
//  ViewController.swift
//  Marindecker
//
//  Created by craptone on 2021/01/12.
//

import UIKit
import WebKit
import SafariServices

import Optik


class ViewController: UIViewController, UIScrollViewDelegate, UIAdaptivePresentationControllerDelegate {
    var swipeStruct = {
        return SwipeStruct()
    }()
    
    var webView: WKWebView!
    public var javaScriptString = ""
    @IBOutlet weak var mainDeckView: UIView!
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var topBackView: UIView!
    @IBOutlet weak var debugFloatingBtn: UIButton!
    
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


    lazy var loadingIndicator: UIActivityIndicatorView = {
        let ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.style = .medium
        return ActivityIndicator
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        self.view.addSubview(loadingIndicator)

        loadingIndicator.startAnimating()
        
        // FIXME
        menuVC = self.children[0] as! MenuViewController
        menuVC.delegate = self
        
        let webConfiguration = WKWebViewConfiguration()

        let userContentController = WKUserContentController()
        // FIXME: 循環参照の恐れアリ。
        userContentController.add(self, name: "jsCallbackHandler")
        userContentController.add(self, name: "imagePreviewer")
        userContentController.add(self, name: "imageViewPos")
        userContentController.add(self, name: "viewDidLoad")
        userContentController.add(self, name: "openSettings")
        userContentController.add(self, name: "loadImage")

        webConfiguration.userContentController = userContentController

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
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



        let deckURL = URL(string: "https://tweetdeck.twitter.com")
//        let deckURL = URL(string: " https://mobile.twitter.com/login?hide_message=true&redirect_after_login=https://tweetdeck.twitter.com")

        let myRequest = URLRequest(url: deckURL!)
        webView.load(myRequest)
        
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: view)
        }

    }
    
    func setupView() {
        self.view.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        self.bottomBackView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        self.topBackView.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        
        imageView.center = view.center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill

        debugFloatingBtn.layer.cornerRadius = 48 / 2
        debugFloatingBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        debugFloatingBtn.layer.shadowColor = UIColor.black.cgColor
        debugFloatingBtn.layer.shadowOpacity = 0.9
        debugFloatingBtn.layer.shadowRadius = 4
        debugFloatingBtn.isHidden = true
        
        mainDeckView.backgroundColor = .none
        
        mainDeckBlurView = UIView(frame: CGRect(origin: .zero, size: view.bounds.size))
        mainDeckBlurView.backgroundColor = .none
        mainDeckBlurView.isUserInteractionEnabled = false
        
//        menuView.translatesAutoresizingMaskIntoConstraints = true
//        mainDeckView.translatesAutoresizingMaskIntoConstraints = true
    }
    

    override var canBecomeFirstResponder: Bool {
        get { return true }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        
//        self.menuView.frame.origin.x = -self.menuView.frame.width
    }


    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("presentationControllerDidDismiss!!!!!!!!!!!!!!")
        self.imageView.removeFromSuperview()
    }


//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//             scrollView.pinchGestureRecognizer?.isEnabled = false
//    }

    @IBAction func debugPressed() {
        let vc = DebugerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func debugJS(script: String) -> (String, Error?) {
        let (ret, error) = webView.evaluateWithError(javaScript: script)
//        print(ret, error)
        return ((ret as? String) ?? "", error)
    }
    
    func openSettings() {
        self.performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    func getUserIcon() -> String{
        return (webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app.is-condensed > header > div > div.js-account-summary > a > div > img').src") as? String) ?? "https://pbs.twimg.com/media/Ewk-ESrUYAAZYKe?format=jpg&name=medium"
    }
    
    func getUserNameID() -> (String, String) {
        let userName = webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app > header > div > div.js-account-summary > a > div > div > div > span').innerText") as? String ?? "unknown"
        let userID = webView.evaluate(javaScript: "document.querySelector('body > div.application.js-app > header > div > div.js-account-summary > a > div > div > span').innerText") as? String ?? "@unknown"
        return (userName, userID)
    }
    
    @IBAction func panTop(sender: UIScreenEdgePanGestureRecognizer) {
        let move:CGPoint = sender.translation(in: view)
        
        if self.menuView.frame.origin.x > 0 && 0 < move.x{
            
        }else{
            mainDeckView.center.x += move.x
            mainDeckBlurView.center.x += move.x
            self.menuView.center.x += move.x
        }
        
        self.view.layoutIfNeeded()
        
        if (sender.state == .began){
            menuView.translatesAutoresizingMaskIntoConstraints = true
            mainDeckView.translatesAutoresizingMaskIntoConstraints = true
            
            menuVC.setUserIcon(url: getUserIcon())
            let (name, id) = getUserNameID()
            menuVC.setUserNameID(name: name, id: id)
            mainDeckBlurView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        }
        
        else if(sender.state == .ended || sender.state == .cancelled || sender.state == .failed) {
            if mainDeckView.frame.origin.x > self.view.frame.width/3{
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
    


}


extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // FIXME
        switch message.name {
                // MARK: WKWebView Didload
        case "viewDidLoad":
            self.loadingIndicator.stopAnimating()
            self.debugFloatingBtn.isHidden = false
            self.mainDeckView.addSubview(webView)
            self.view.addSubview(mainDeckBlurView)
            // FIXME
            self.bottomBackView.backgroundColor = #colorLiteral(red: 0.1075549349, green: 0.1608583331, blue: 0.2208467424, alpha: 1)
//            self.view.backgroundColor = UIColor(hex: "F5F5F5")
//            self.bottomBackView.backgroundColor = UIColor(hex: "ffffff")
//            self.topBackView.backgroundColor = UIColor(hex: "F5F5F5")
            self.bottomBackView.isHidden = false
            webView.anchorAll(equalTo: mainDeckView)
            
            menuVC.setUserIcon(url: getUserIcon())

        case "jsCallbackHandler":
            print("JS Log:", message.body)

        case "imageViewPos":
            guard let imgpos = message.body as? [Int] else {
                return
            }
            print("IMGPOS!!!: ", imgpos)
//            imageView.center = view.center
//            imageView.frame.origin.y = view.frame.origin.y

            imageView.frame = CGRect(x: imgpos[0], y: imgpos[1] + Int(UIApplication.shared.statusBarFrame.size.height), width: imgpos[2], height: imgpos[3])

        case "openSettings":
            print("openSettings")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.performSegue(withIdentifier: "toSettings", sender: nil)
            }


        case "loadImage":
//            guard let url = (message.body as? String) else {
//                return
//            }
//            print("loading image", url)
//            url2UIImage(url: url2NomalImg(url))
            break


        case "imagePreviewer":
            let valueStrings = message.body as! [Any]
            let index = valueStrings[0] as! Int
            let urls = valueStrings[1] as! [String]

            print("value!!!!", index, urls)

            var imgUrls = urls.map({
                url2NomalImg($0)
            })
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


        default:
            return
        }
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
        r = r.replacingOccurrences(of: "&name=small", with: "&name=large")
        return r
    }

    override var previewActionItems: [UIPreviewActionItem] {
        let edit = UIPreviewAction(title: "編集", style: .default) { _, _ in
            print("編集をタップ")
        }

        let delete = UIPreviewAction(title: "削除", style: .destructive) { _, _ in
            print("削除をタップ")
        }

        return [edit, delete]
    }
}


// MARK: - 10 WKWebView ui delegate
extension ViewController: WKUIDelegate {
    // delegate

}

// MARK: - 11 WKWebView WKNavigation delegate
extension ViewController: WKNavigationDelegate {
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        let host = url?.host
        
        if host == "tweetdeck.twitter.com" || host == "mobile.twitter.com" {
            decisionHandler(.allow)
        }else{
            let safariVC = SFSafariViewController(url: url!)
            present(safariVC, animated: true, completion: nil)
            
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let mtPath = Bundle.main.path(forResource: "mtdeck", ofType: "js") else {
            print("LoadError MTDeck")
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
        guard let marinPath = Bundle.main.path(forResource: "marindeck", ofType: "js") else {
            print("LoadError MarinDeck")
            return
        }
        let marinFile = FileHandle(forReadingAtPath: marinPath)!
        let marinContentData = marinFile.readDataToEndOfFile()
        let marinContentString = String(data: marinContentData, encoding: .utf8)!
        marinFile.closeFile()

        let marinScript = marinContentString
        webView.evaluateJavaScript(marinScript) { object, error in
            print("webViewLog : ", error ?? "成功")
        }
    }

    public func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        let vc = UIViewController()
        return vc
    }
    

//    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKContextMenuElementInfo) -> Bool { return false }

}

extension ViewController: MenuDelegate {
    
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

extension ViewController: UIViewControllerPreviewingDelegate {

    func getPositionElements(x: Int, y: Int) -> (Int, [String]) {
        guard let value = webView.evaluate(javaScript: "positionElement(\(x), \(y))") else {
            return (0, [])
        }
        let valueStrings = value as! [Any]
        let index = valueStrings[0] as! Int
        let urls = valueStrings[1] as! [String]

        print("value!!!!", index, urls)

        var imgUrls = urls.map({
            url2NomalImg($0)
        })

        return (index, imgUrls)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if isMenuOpen{return nil}
        let imgurl = getPositionElements(x: Int(location.x), y: Int(location.y))
        if imgurl.1.count == 0 {
            return nil
        }
        if imgurl.1[0] == "" {
            print("img is nil...")
            return nil
        }
        let imgs = imgurl.1.map({
            url2UIImage(url: $0)
        })

        self.view.addSubview(imageView)
        let imageViewer = Optik.imageViewer(
                withImages: imgs,
                initialImageDisplayIndex: imgurl.0,
                delegate: self
        )
//        imageViewer.view.backgroundColor = .none
//        setBlurView()
        return imageViewer

    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }

}


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


