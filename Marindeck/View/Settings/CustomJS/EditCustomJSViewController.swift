//
//  EditCustomJSViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/04/12.
//

import UIKit
import Highlightr

class EditCustomJSViewController: UIViewController {
    private lazy var dbQueue = Database.shared.dbQueue

    private var index: Int!
    private var customJS: CustomJS!
    var textView: UITextView!

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!

//    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = customJS.title
        navigationController?.navigationBar.backgroundColor = .backgroundColor

        let textStorage = CodeAttributedString()
        textStorage.language = "javascript"
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

//        let textContainer = NSTextContainer(size: view.bounds.size)
        // FIXME
        let textContainer = NSTextContainer(size: CGSize(width: view.bounds.size.width, height: 100000000000))
        layoutManager.addTextContainer(textContainer)

        textView = UITextView(frame: editorView.bounds, textContainer: textContainer)
//        textView = UITextView(frame: view.bounds)
//        textView.contai
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        textView.textColor = UIColor(white: 0.8, alpha: 1.0)
        textView.inputAccessoryView = toolbar
        editorView.addSubview(textView)
//        view.addSubview(textView)

        textView.text = customJS.js
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
        updateJS()
        let bvc = self.presentingViewController as? CustomJSViewController
        bvc?.updateCustomJSs()
        bvc?.tableView.reloadData()
    }

    init(customJS: CustomJS) {
        super.init(nibName: nil, bundle: nil)
        
        self.customJS = customJS
    }

    func updateJS() {
        if customJS.js == textView.text {
            return
        }
        
        customJS.js = textView.text
        
        try! dbQueue.write { db in
            try self.customJS.update(db)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)

        updateJS()
    }

    @IBAction func keyboardDonePressed(_ sender: Any) {
        textView.resignFirstResponder()
    }
}
