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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "デフォルト"
        applyBtn.layer.cornerRadius = 6
        previewBtn.layer.cornerRadius = 6
        
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
        UserDefaults.standard.setValue("0", forKey: UserDefaultsKey.themeID)
        reload()
    }
    
    @IBAction func apply() {
        UserDefaults.standard.setValue("1", forKey: UserDefaultsKey.themeID)
        reload()
    }
    
}
