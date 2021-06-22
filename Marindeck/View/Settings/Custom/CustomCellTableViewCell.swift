//
//  CustomJSCellTableViewCell.swift
//  Marindeck
//
//  Created by craptone on 2021/04/12.
//

import UIKit


class CustomCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .backgroundColor
        self.backView.layer.cornerRadius = 8
        backView.backgroundColor = .secondaryBackgroundColor
        titleLabel.textColor = .labelColor
        dateLabel.textColor = .subLabelColor
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
