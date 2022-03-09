//
//  ThemeDetailViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/09.
//

import UIKit

class ThemeDetailViewController: UIViewController {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var previewBtn: UIButton!

    public var theme: Theme? {
        didSet {
            titleLabel?.text = theme?.title
            descriptionTextView?.text = theme?.description
            //            iconView.image = theme?.icon
            userLabel?.text = "by \(theme?.user ?? "不明")"
        }
    }

    public var viewController: ViewController!

    private var isApplied = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = theme?.title
        applyBtn.layer.cornerRadius = 6
        previewBtn.layer.cornerRadius = 6

        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width / 2
        iconView.image = UIImage(named: theme?.icon ?? "") ?? Asset.marindeckLogo.image
        titleLabel?.text = theme?.title
        descriptionTextView?.text = theme?.description
        //            iconView.image = theme?.icon
        userLabel?.text = theme?.user

        reload()
        
        setSwipeBack()
    }

    func reload() {
        view.backgroundColor = .secondaryBackgroundColor
        navigationController?.navigationBar.tintColor = .labelColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelColor]

        titleLabel.textColor = .labelColor
        userLabel.textColor = .subLabelColor
        descriptionTextView.textColor = .subLabelColor

        if let themeID = UserDefaults.standard.string(forKey: UserDefaultsKey.themeID) {
            if themeID == theme?.id {
                isApplied = true
            }
        }

        if isApplied {
            applyBtn.backgroundColor = .backgroundColor
            applyBtn.setTitle("適用済", for: .normal)
            applyBtn.setTitleColor(.subLabelColor, for: .normal)

        } else {
            applyBtn.backgroundColor = .systemBlue
            applyBtn.setTitle("適用", for: .normal)
        }
    }

    @IBAction func preview() {
        //        UserDefaults.standard.setValue("0", forKey: UserDefaultsKey.themeID)
        //        reload()
    }

    @IBAction func apply() {
        if isApplied { return }
        UserDefaults.standard.set( theme?.id, forKey: .themeID)
        viewController.webView.reload()
        reload()
    }

}
