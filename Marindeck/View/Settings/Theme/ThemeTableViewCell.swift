//
//  ThemeTableViewCell.swift
//  Marindeck
//
//  Created by craptone on 2021/05/06.
//

import UIKit

protocol ThemeTableViewCellDelegate {
    func apply(tag: Int)
}

class ThemeTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    public var delegate: ThemeTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = iconView.frame.width / 2
        backView.layer.cornerRadius = 8
        applyButton.layer.cornerRadius = 8
        applyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    
        selectionStyle = .none
        
//        self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @IBAction func apply() {
        delegate.apply(tag: self.tag)
    }
    
//    @objc func tapped() {
//        backView.backgroundColor = .gray
//        UIView.animate(withDuration: 0.3, animations: {
//            self.backView.backgroundColor = .systemBackground
//        })
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    
}
