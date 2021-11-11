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

    var label:UILabel!
//    var picker:UIPickerView!

    let items: [ActionButtons] = [
        .debug, .draft, .gif, .menu, .settings, .tweet
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label = UILabel()
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.font = UIFont.systemFont(ofSize: 30)
        self.label.textAlignment = .center
        self.view.addSubview(self.label)
        
        self.label.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.label.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
               
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel.backgroundColor = .secondaryBackgroundColor
        infoLabel.textColor = .subLabelColor
        infoLabel.clipsToBounds = true
        infoLabel.layer.cornerRadius = 4
        infoLabel.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        setInfo(message: "ツイートボタンを長押ししたときに出てくるアクションボタンを設定できます。")
    }
    
    func setInfo(message: String) {
        let text = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "info.circle")!))
        text.append(NSAttributedString(string: message))
        infoLabel.attributedText = text
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
//        switch component {
//        case 0:
//            return items1.count
//        case 1:
//            return items2.count
//        default:
//            return 0
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row].getTitle()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        NSAttributedString(attachment: NSTextAttachment(image: items[row].getImage()))
        let attribute: AttributedString = "\(items[row].getImage()) \(items[row].getTitle())"
        return attribute as! NSAttributedString
    }
    
    //選択されたときの動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.label.text = "􀅴" + items[row].rawValue
        case 1:
            self.label.text = "􀅴" + items[row].rawValue
        default:
            return
        }
    }
}
