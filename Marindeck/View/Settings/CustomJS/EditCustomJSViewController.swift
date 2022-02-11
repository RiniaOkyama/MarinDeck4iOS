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

    private var customJS: CustomJS!
    var textView: UITextView!

    private lazy var editorViewConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: textView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    }()

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = customJS.title
        navigationController?.navigationBar.backgroundColor = .secondaryBackgroundColor

        let textStorage = CodeAttributedString()
        textStorage.language = "javascript"
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        //        let textContainer = NSTextContainer(size: view.bounds.size)
        // FIXME
        let textContainer = NSTextContainer(size: CGSize(width: view.bounds.size.width, height: 100_000_000_000))
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
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.view.addConstraint(editorViewConstraint)

        textView.text = customJS.js

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateJS()
        let bvc = navigationController?.viewControllers.last as? CustomJSViewController
        bvc?.updateCustomJSs()
        bvc?.tableView.reloadData()
    }

    init(customJS: CustomJS) {
        super.init(nibName: nil, bundle: nil)

        self.customJS = customJS
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardHeight = notification.keyboardHeight,
              let keyboardAnimationDuration = notification.keybaordAnimationDuration,
              let KeyboardAnimationCurve = notification.keyboardAnimationCurve
        else { return }

        self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = false
        UIView.animate(withDuration: keyboardAnimationDuration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: KeyboardAnimationCurve)) {
            //            self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight).isActive = true
            self.view.removeConstraint(self.editorViewConstraint)
            self.editorViewConstraint.constant = -keyboardHeight
            self.view.addConstraint(self.editorViewConstraint)

        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.removeConstraint(self.editorViewConstraint)
        self.editorViewConstraint.constant = 0
        self.view.addConstraint(self.editorViewConstraint)
    }

    func updateJS() {
        if customJS.js == textView.text {
            return
        }

        customJS.js = textView.text

        try! dbQueue.write { db in
            try customJS.update(db)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)

        updateJS()
    }

    @IBAction func keyboardDonePressed(_ sender: Any) {
        textView.resignFirstResponder()
    }
}
