//
//  EditCustomJSViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/04/12.
//

import UIKit
import Highlightr

class EditCustomJSViewController: UIViewController {
    private let userDefaults = UserDefaults.standard

    private var index: Int!
    private var customJS: CustomJS!
    var textView : UITextView!

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
//    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        
        fetchJS()
        
        textView.text = customJS.js
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateJS()
    }
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.index = index
    }
    
    func fetchJS(){
        let jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        
        let jsonData = jsonArray.reversed()[self.index].data(using: .utf8)!
        
        customJS = try! JSONDecoder().decode(CustomJS.self, from: jsonData)
    }
    func updateJS() {
        var jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        customJS.created_at = Date()
        customJS.js = textView.text
        let jsonData = try! JSONEncoder().encode(customJS)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        jsonArray[jsonArray.count - self.index - 1] = jsonString
        userDefaults.set(jsonArray, forKey: UserDefaultsKey.customJSs)
        
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
