//
//  CustomJSCellTableViewCell.swift
//  Marindeck
//
//  Created by Rinia on 2021/04/12.
//

import UIKit

protocol CustomCellTableViewCellOutput {
    func switched(isOn: Bool, index: Int?)
}

class CustomCellTableViewCell: UITableViewCell {
    public var delegate: CustomCellTableViewCellOutput?
    public var index: Int?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!

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

    @IBAction func switched() {
        delegate?.switched(isOn: switchView.isOn, index: index)
    }

}
