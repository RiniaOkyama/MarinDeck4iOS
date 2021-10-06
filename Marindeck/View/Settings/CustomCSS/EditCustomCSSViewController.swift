//
//  EditCustomCSSViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/06/22.
//

import UIKit
import Highlightr
import RealmSwift

class EditCustomCSSViewController: UIViewController {
    var textView: UITextView!
//    private let realm = try! Realm()
    private var realm = try! Realm()
    private var customCSS: CustomCSS!

    @IBOutlet weak var editorView: UIView!
//    @IBOutlet weak var toolbar: UIToolbar!
//    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textStorage = CodeAttributedString()
        textStorage.language = "css"
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: CGSize(width: view.bounds.size.width, height: .greatestFiniteMagnitude))
        layoutManager.addTextContainer(textContainer)
        
        textView = UITextView(frame: editorView.bounds, textContainer: textContainer)

        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        textView.textColor = UIColor(white: 0.8, alpha: 1.0)
//        textView.inputAccessoryView = toolbar
        editorView.addSubview(textView)
//        view.addSubview(textView)
        
        textView.text = customCSS.css
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.editorView.resignFirstResponder()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateCSS()
        let bvc = self.presentingViewController as? CustomCSSViewController
        bvc?.updateCustomCSSs()
        bvc?.tableView.reloadData()
    }
    
    init(customCSS: CustomCSS) {
        super.init(nibName: nil, bundle: nil)
        
        self.customCSS = customCSS
    }
    
    
    func updateCSS() {
        try! realm.write({
            customCSS.css = textView.text
            customCSS.created_at = Date()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
        
//        updateCSS()
    }
    
    @IBAction func keyboardDonePressed(_ sender: Any) {
        textView.resignFirstResponder()
    }
}
