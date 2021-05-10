//
//  ThemeDetailViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/05/09.
//

import UIKit

class ThemeDetailViewController: UIViewController {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var previewBtn: UIButton!
    
    public var theme: Theme? = nil {
        didSet {
            titleLabel?.text = theme?.title
            descriptionTextView?.text = theme?.description
//            iconView.image = theme?.icon
            userLabel?.text = "by \(theme?.user)"
        }
    }
    
    public var viewController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = theme?.title
        applyBtn.layer.cornerRadius = 6
        previewBtn.layer.cornerRadius = 6
        
        titleLabel?.text = theme?.title
        descriptionTextView?.text = theme?.description
//            iconView.image = theme?.icon
        userLabel?.text = theme?.user
        
        reload()
    }
    
    func reload() {
        view.backgroundColor = .secondaryBackgroundColor
        navigationController?.navigationBar.tintColor = .labelColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelColor]
        
        titleLabel.textColor = .labelColor
        userLabel.textColor = .subLabelColor
        descriptionTextView.textColor = .subLabelColor
    }
    
    @IBAction func preview() {
//        UserDefaults.standard.setValue("0", forKey: UserDefaultsKey.themeID)
//        reload()
    }
    
    @IBAction func apply() {
        UserDefaults.standard.setValue( theme?.id, forKey: UserDefaultsKey.themeID)
        viewController.webView.reload()
        reload()
    }
    
}
