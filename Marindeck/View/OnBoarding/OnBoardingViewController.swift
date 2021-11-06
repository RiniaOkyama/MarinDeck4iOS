//
//  OnBoardingViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/06.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var startMarinDeckButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        startMarinDeckButton.setTitle(L10n.OnBoarding.StartMarinDeck.title, for: .normal)
        
        
        view.backgroundColor = .backgroundColor
    }
    
    @IBAction func start() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isOnBoarding)
        dismiss(animated: true)
    }
}
