//
//  MenuViewController.swift
//  Marindecker
//
//  Created by craptone on 2021/03/15.
//

import UIKit

protocol MenuDelegate {
    func openSettings()
    func reload()
}

class MenuViewController: UIViewController {
    var delegate: MenuDelegate!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var profileMenu: MenuItemView!
    @IBOutlet weak var reloadMenu: MenuItemView!
    @IBOutlet weak var columnMenu: MenuItemView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .backgroundColor
        
        nameLabel.textColor = .labelColor
        idLabel.textColor = .subLabelColor
        
        userIconImageView.clipsToBounds = true
        userIconImageView.layer.cornerRadius = 30
        
        [profileMenu, reloadMenu, columnMenu].forEach({
            $0?.iconView.tintColor = .labelColor
            $0?.titleLabel.textColor = .labelColor
        })
        settingsButton.tintColor = .labelColor
        
        profileMenu.setTapEvent(action: #selector(profileTapped), target: self)
        reloadMenu.setTapEvent(action: #selector(reloadTapped), target: self)


    }
    
    @objc func profileTapped() {
        self.profileMenu.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        UIView.animate(withDuration: 0.3, animations: {
            self.profileMenu.backgroundColor = .clear
        })
    }
    
    @objc func reloadTapped() {
        self.reloadMenu.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        UIView.animate(withDuration: 0.3, animations: {
            self.reloadMenu.backgroundColor = .clear
        })
        delegate.reload()
    }
    
    func setUserIcon(url:String){
        userIconImageView.image = UIImage(url: url)
    }
    
    func setUserNameID(name: String, id: String) {
        nameLabel.text = name
        idLabel.text = id
    }
    

    @IBAction func openSettings(){
        delegate.openSettings()
    }

}
