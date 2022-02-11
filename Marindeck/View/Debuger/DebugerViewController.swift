//
//  DebugerViewController.swift
//  Marindecker
//
//  Created by Rinia on 2021/01/16.
//

import UIKit
import Highlightr
import WebKit

class DebugerViewController: UIViewController {
    // FIXME
    weak var delegate: ViewController?
    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!

    private var textView: UITextView!
    private var textStorage: CodeAttributedString!

    override func viewDidLoad() {
        super.viewDidLoad()

        textStorage = CodeAttributedString()
        textStorage.language = "JavaScript"
        textStorage.highlightr.setTheme(to: "atom-one-dark")
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: CGSize(width: view.bounds.size.width, height: 100_000_000_000))
        layoutManager.addTextContainer(textContainer)

        textView = UITextView(frame: editorView.bounds, textContainer: textContainer)
        textView.autocorrectionType = .no
        textView.smartQuotesType = .no
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        //        textView.inputAccessoryView = TOOLBAR
        //        self.view.addSubview(textView)
        self.editorView.addSubview(textView)
        self.view.bringSubviewToFront(segmentCtrl)

        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 128, right: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShowNotification(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 128, right: 0)
    }

    func errorAlert(_ string: String) {
        let alert: UIAlertController = UIAlertController(title: "実行エラー", message: string, preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (_: UIAlertAction!) -> Void in
            print("OK")
        })
        alert.addAction(defaultAction)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func segmentButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            textStorage.language = "JavaScript"
        case 1:
            textStorage.language = "css"
        default:break
        }
    }

    @IBAction func run() {
        let script = segmentCtrl.selectedSegmentIndex == 0 ? textView.text! : WKWebView.css2JS(css: textView.text!)
        let (_, error) = delegate!.webView.inject(js: script)

        if error != nil {
            print(error!)
            if error!.code == 5 {
                print("asできません。。。")
            } else {
                let errorlog = (error!.info["WKJavaScriptExceptionMessage"].unsafelyUnwrapped as! String)
                    + "\n\nLine: " + String(error!.info["WKJavaScriptExceptionLineNumber"].unsafelyUnwrapped as! Int)
                errorAlert(error!.localizedDescription + "\n\n" + errorlog)
                return
            }
        }
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
