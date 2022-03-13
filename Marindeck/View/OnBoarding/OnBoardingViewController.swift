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
        startMarinDeckButton.backgroundColor = .tweetButtonColor
        startMarinDeckButton.setTitleColor(.labelColor, for: .normal)
        startMarinDeckButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        view.backgroundColor = .backgroundColor

        startMarinDeckButton.clipsToBounds = true
        startMarinDeckButton.layer.cornerRadius = 6
    }

    @IBAction func start() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.isOnBoarding)
        dismiss(animated: true)
    }
}
