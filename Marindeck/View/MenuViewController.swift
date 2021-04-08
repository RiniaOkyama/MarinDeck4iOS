//
//  MenuViewController.swift
//  Marindecker
//
//  Created by craptone on 2021/03/15.
//

import UIKit

protocol MenuDelegate {
    func openSettings()
}

class MenuViewController: UIViewController {
    var delegate: MenuDelegate!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME
        self.view.backgroundColor = #colorLiteral(red: 0.08181380481, green: 0.1257319152, blue: 0.1685300171, alpha: 1)
        
        userIconImageView.clipsToBounds = true
        userIconImageView.layer.cornerRadius = 30
        

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
