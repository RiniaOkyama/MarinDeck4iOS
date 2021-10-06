//
//  MenuItemView.swift
//  Marindeck
//
//  Created by Rinia on 2021/05/06.
//

import UIKit

@IBDesignable
final class MenuItemView: UIView {
    
    @IBInspectable var iconImage: UIImage? {
        didSet {
            iconView.image = iconImage
        }
//        get { return iconView.image }
//        set { iconView.image = newValue }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public lazy var iconView: UIImageView = {
       let imgView = UIImageView()
        imgView.frame.size.height = self.frame.height
        imgView.frame.size.width = 22
        imgView.frame.origin.x = 12
        imgView.contentMode = .scaleAspectFit
        imgView.image = iconImage
        imgView.tintColor = .labelColor
        return imgView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame.size.height = self.frame.height
        label.frame.size.width =  self.frame.width - (36 + 12)
        label.frame.origin.x = 36 + 12
        label.textColor = .labelColor
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func awakeFromNib() {
         super.awakeFromNib()
         setupViews()
     }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
//        setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupViews() {
        self.addSubview(iconView)
        self.addSubview(titleLabel)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = .clear
    }
    
    public func setTapEvent(action: Selector, target: Any) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .clear
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = .clear
        })
    }

}
