//
//  EditActionButtonViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/11.
//

import UIKit

class EditActionButtonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tweetBtn: NDTweetBtn!

    private var selectedActions: [ActionButtons] = [.debug, .settings, .tweet] // FIXME
//    var picker:UIPickerView!

    let items: [ActionButtons] = [
        .debug, .draft, .gif, .menu, .settings, .tweet
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel.backgroundColor = .secondaryBackgroundColor
        infoLabel.textColor = .subLabelColor
        infoLabel.clipsToBounds = true
        infoLabel.layer.cornerRadius = 4
        infoLabel.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        setInfo(message: "ツイートボタンを長押ししたときに出てくるアクションボタンを設定できます。")

        selectedActions = getActions()
        pickerView.selectRow(items.firstIndex(of: selectedActions[0]) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(items.firstIndex(of: selectedActions[1]) ?? 0, inComponent: 1, animated: false)
        pickerView.selectRow(items.firstIndex(of: selectedActions[2]) ?? 0, inComponent: 2, animated: false)
        updateActions()
        tweetBtn.isPressing = true
        tweetBtn.isLock = true
    }

    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)

        title = L10n.Settings.CustomActonButtons.Cell.title
        navigationController?.navigationBar.backgroundColor = .backgroundColor
        view.backgroundColor = .backgroundColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingViewController?.endAppearanceTransition()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    func setInfo(message: String) {
        let text = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "info.circle")!))
        text.append(NSAttributedString(string: " \(message)"))
        infoLabel.attributedText = text
    }
    
    func updateActions() {
        tweetBtn.removeAllActions()
        selectedActions.forEach {
            let action = NDTweetBtnAction(
                    image: $0.getImage(),
                    handler: { _ in }
            )
            tweetBtn.addAction(action: action)
        }
    }

    func saveActions() {
        UserDefaults.standard.set(selectedActions.map { $0.rawValue }, forKey: UserDefaultsKey.actionButtoms)
    }

    func getActions() -> [ActionButtons] {
        guard let ab = UserDefaults.standard.array(forKey: UserDefaultsKey.actionButtoms) as? [String] else {
            return [.debug, .settings, .tweet]
        }
        return ab.compactMap{ ActionButtons(rawValue: $0) }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: items[row].getTitle(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.labelColor])
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setInfo(message: items[row].getDescription())
        selectedActions[component] = items[row]

        updateActions()
        saveActions()
    }
}
