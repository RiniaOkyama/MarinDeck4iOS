//
//  ViewController+MenuView.swift
//  Marindeck
//
//  Created by a on 2022/02/11.
//

import Foundation
import class UIKit.UIView
import class UIKit.UIColor


protocol MenuAction {
    func closeMenu()
    func openMenu()
}

extension ViewController: MenuDelegate {
    func reload() {
        webView.reload()
        closeMenu()
    }

    func openProfile() {
        closeMenu()
        webView.evaluateJavaScript("document.querySelector(\"body > div.application.js-app.is-condensed > header > div > div.js-account-summary > a > div\").click()") { object, error in
            print("openProfile : ", error ?? "成功")
        }
    }

    func openColumnAdd() {
        closeMenu()
        webView.evaluateJavaScript("document.querySelector(\".js-header-add-column\").click()") { object, error in
            print(#function, error ?? "成功")
        }
    }
}

extension ViewController: MenuAction {
    // Menuを閉じる
    func closeMenu() {
        isMenuOpen = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        mainDeckView.translatesAutoresizingMaskIntoConstraints = false
        mainDeckBlurView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.mainDeckBlurView.backgroundColor = .none

            self.mainDeckBlurView.frame.origin.x = 0
            self.mainDeckView.frame.origin.x = 0
            self.bottomBackView.frame.origin.x = 0
            self.topBackView.frame.origin.x = 0

            self.menuView.frame.origin.x = -self.menuView.frame.width
        })
    }

    // Menuを開く
    func openMenu() {
        isMenuOpen = true
        menuView.translatesAutoresizingMaskIntoConstraints = true
        mainDeckView.translatesAutoresizingMaskIntoConstraints = true
        mainDeckBlurView.isUserInteractionEnabled = true

        td.account.getAccount { [weak self] account in
            self?.menuVC.setUserIcon(url: account.profileImageUrl ?? "")
            self?.menuVC.setUserNameID(name: account.name ?? "", id: account.userId ?? "")
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.x = 0
            self.mainDeckBlurView.frame.origin.x = self.menuView.frame.width
            self.mainDeckView.frame.origin.x = self.menuView.frame.width

            UIView.animate(withDuration: 0.2, animations: {
                self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        })
    }
}
