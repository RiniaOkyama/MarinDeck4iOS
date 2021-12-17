//
//  MenuViewController.swift
//  Marindecker
//
//  Created by Rinia on 2021/03/15.
//

import UIKit

protocol MenuDelegate {
    func openSettings()
    func openProfile()
    func openColumnAdd()
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
    
    @IBOutlet weak var marinDeckLogoView: UIImageView!

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
        marinDeckLogoView.image =  marinDeckLogoView.image?.withRenderingMode(.alwaysTemplate)
        marinDeckLogoView.tintColor = .labelColor
        profileMenu.setTapEvent(action: #selector(profileTapped), target: self)
        reloadMenu.setTapEvent(action: #selector(reloadTapped), target: self)
        columnMenu.setTapEvent(action: #selector(columnAddTapped), target: self)

        profileMenu.title = L10n.Menu.Profile.title
        reloadMenu.title = L10n.Menu.Reload.title
        columnMenu.title = L10n.Menu.AddColumn.title
    }
    
    @objc func profileTapped() {
        self.profileMenu.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.1, animations: {
            self.profileMenu.backgroundColor = .clear
        })
        delegate.openProfile()
    }
    
    @objc func reloadTapped() {
        self.reloadMenu.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.1, animations: {
            self.reloadMenu.backgroundColor = .clear
        })
        delegate.reload()
    }
    
    @objc func columnAddTapped() {
        self.columnMenu.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        UIView.animate(withDuration: 0.1, animations: {
            self.columnMenu.backgroundColor = .clear
        })
        delegate.openColumnAdd()
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
