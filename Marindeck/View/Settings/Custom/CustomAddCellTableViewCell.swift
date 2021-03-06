//
//  CustomJSAddCellTableViewCell.swift
//  Marindeck
//
//  Created by Rinia on 2021/04/12.
//

import UIKit

protocol CustomAddCellOutput {
    func create()
}

class CustomAddCellTableViewCell: UITableViewCell {
    public var delegate: CustomAddCellOutput!

    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .backgroundColor
        backView.layer.cornerRadius = 8
        backView.backgroundColor = .secondaryBackgroundColor

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.create))
        backView.addGestureRecognizer(gesture)

    }

    @objc
    func create() {
        delegate?.create()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
