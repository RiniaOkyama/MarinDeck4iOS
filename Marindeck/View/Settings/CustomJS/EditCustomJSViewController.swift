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
    var textView: UITextView!

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
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.index = index
    }
    
    func fetchCustomJSs() -> [CustomJS] {
        let jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        var retArray: [CustomJS] = []
        for item in jsonArray {
            let jsonData = item.data(using: .utf8)!
            retArray.append(try! JSONDecoder().decode(CustomJS.self, from: jsonData))
        }
        return retArray
    }
    
    func fetchJS(){
        customJS = fetchCustomJSs().sorted(by: { $0.created_at > $1.created_at })[self.index]
    }
    func updateJS() {
//        var jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        if customJS.js == textView.text {
            return
        }
        customJS.js = textView.text
//        let jsonData = try! JSONEncoder().encode(customJS)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        jsonArray[jsonArray.count - self.index - 1] = jsonString
//        userDefaults.set(jsonArray, forKey: UserDefaultsKey.customJSs)
        
        let cjss = fetchCustomJSs()
        let itemindex = cjss.firstIndex(where: { $0.created_at == customJS.created_at })!
        customJS.created_at = Date()

        var jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        let jsonData = try! JSONEncoder().encode(customJS)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        jsonArray[itemindex] = jsonString
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
