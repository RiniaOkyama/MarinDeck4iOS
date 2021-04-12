//
//  DebugerViewController.swift
//  Marindecker
//
//  Created by craptone on 2021/01/16.
//

import UIKit
import Highlightr
//HighlightView

class DebugerViewController: UIViewController {
    var delegate: ViewController?
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

        let textContainer = NSTextContainer(size: view.bounds.size)
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

        // Do any additional setup after loading the view.
    }
    
    func errorAlert(_ string: String){
        let alert: UIAlertController = UIAlertController(title: "実行エラー", message: string, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
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
    
    @IBAction func run(){
        var script = ""
        if segmentCtrl.selectedSegmentIndex == 1{
            var deletecomment = textView.text!.replacingOccurrences(of: "[\\s\\t]*/\\*/?(\\n|[^/]|[^*]/)*\\*/", with: "")
            deletecomment = deletecomment.replacingOccurrences(of: "\"", with: "\\\"")
            deletecomment = deletecomment.replacingOccurrences(of: "\n", with: "\\\n")
            print(deletecomment)
            script = """
var s = document.createElement("style");
s.innerHTML = "\(deletecomment)";
document.getElementsByTagName("head")[0].appendChild(s);
"""
        }else{
            script = textView.text
        }
        let (_, error) = delegate!.debugJS(script: script)
        
        if error != nil{
            print(error)
            if error!.code == 5{
                print("asできません。。。")
            }else{
                let errorlog = (error!.info["WKJavaScriptExceptionMessage"].unsafelyUnwrapped as! String) + "\n\nLine: " + String(error!.info["WKJavaScriptExceptionLineNumber"].unsafelyUnwrapped as! Int)
                errorAlert(error!.localizedDescription + "\n\n" + errorlog)
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }


}

