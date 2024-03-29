//
//  ViewController+Swipe.swift
//  Marindecker
//
//  Created by Rinia on 2021/03/15.
//

import Foundation
import UIKit

struct SwipeStruct {
    var isMenuCloseRight: Bool = false
    var isFirstTouch: Bool = false
    var isMoving = false
}

extension ViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeStruct.isFirstTouch = true
        swipeStruct.isMoving = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeStruct.isMoving = true
        if !isMenuOpen {
            return
        }

        let touchevent = touches.first!
        //        let view = touchevent.view!
        let old = touchevent.previousLocation(in: self.view)
        let new = touchevent.location(in: self.view)

        let move_x = new.x - old.x
        //        let move_y = new.y - old.y

        //        if swipeStruct.isFirstTouch{
        //            print(move_x, move_y)
        //            swipeStruct.isMenuCloseRight = abs(move_x) > abs(move_y)
        //            swipeStruct.isFirstTouch = false
        //
        //            if swipeStruct.isMenuCloseRight{
        //                UIView.animate(withDuration: 0.2, animations: {
        //                    self.mainDeckBlurView.backgroundColor = .none
        //                })
        //            }else{
        //                return
        //            }
        //        }
        //
        //        if !swipeStruct.isMenuCloseRight{return}

        if self.menuView.frame.origin.x > 0 && 0 < move_x {

        } else {
            mainDeckView.center.x += move_x
            mainDeckBlurView.center.x += move_x
            self.menuView.center.x += move_x
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swipeStruct.isMoving {
            closeMenu()
            return
        }
        swipeStruct.isMoving = false

        if mainDeckView.frame.origin.x > self.menuView.frame.width / 2 {
            isMenuOpen = true
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame.origin.x = 0
                self.mainDeckBlurView.frame.origin.x = self.menuView.frame.width
                self.mainDeckView.frame.origin.x = self.menuView.frame.width

                UIView.animate(withDuration: 0.2, animations: {
                    self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                })
            })
        } else {
            menuView.translatesAutoresizingMaskIntoConstraints = false
            mainDeckView.translatesAutoresizingMaskIntoConstraints = false
            mainDeckBlurView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                self.mainDeckBlurView.backgroundColor = .none
                //                    self.topBackBlurView.backgroundColor = .none
                //                    self.bottomBackBlurView.backgroundColor = .none

                self.mainDeckBlurView.frame.origin.x = 0
                self.mainDeckView.frame.origin.x = 0
                self.bottomBackView.frame.origin.x = 0
                self.topBackView.frame.origin.x = 0

                self.menuView.frame.origin.x = -self.menuView.frame.width
            })
        }
    }

    // MARK: Menu open
    @objc
    func panTop(sender: UIScreenEdgePanGestureRecognizer) {
        let move: CGPoint = sender.translation(in: view)

        if self.menuView.frame.origin.x > 0 && 0 < move.x {

        } else {
            mainDeckView.center.x += move.x
            mainDeckBlurView.center.x += move.x
            self.menuView.center.x += move.x
        }

        self.view.layoutIfNeeded()

        if sender.state == .began {
            print("began")
            //            isColumnScroll(false)
            menuView.translatesAutoresizingMaskIntoConstraints = false
            mainDeckView.translatesAutoresizingMaskIntoConstraints = false

            // FIXME
            let columnScroll = """
                               const columnScroll = {
                                 style: null,
                                 init: () => {
                                   if (!columnScroll.style) {
                                     columnScroll.style = document.createElement('style')
                                     document.head.insertAdjacentElement('beforeend', columnScroll.style)
                                   }
                                   columnScroll.style.textContent = ''
                                 },
                                 on: () => {
                                   columnScroll.init()
                                   columnScroll.style.insertAdjacentHTML('beforeend', '.app-columns-container{overflow-x:auto!important}')
                                 },
                                 off: () => {
                                   columnScroll.init()
                                   columnScroll.style.insertAdjacentHTML('beforeend', '.app-columns-container{overflow-x:hidden!important}')
                                 }
                               }

                               """
            webView.evaluateJavaScript(columnScroll, completionHandler: { _, _ in
                self.webView.evaluateJavaScript("columnScroll.off()", completionHandler: { (_, error) in
                    print(#function, error ?? "成功")
                })
            })

            mainDeckBlurView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.mainDeckBlurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })

            td.account.getAccount { [weak self] account in
                self?.menuVC.setUserIcon(url: account.profileImageUrl ?? "")
                self?.menuVC.setUserNameID(name: account.name ?? "", id: account.userId ?? "")
            }

        } else if sender.state == .ended || sender.state == .cancelled || sender.state == .failed {
            print("cancel or end or fail")
            //            isColumnScroll(true)
            menuView.translatesAutoresizingMaskIntoConstraints = true
            mainDeckView.translatesAutoresizingMaskIntoConstraints = true

            webView.evaluateJavaScript("columnScroll.on()", completionHandler: { (_, error) in
                print(#function, error ?? "成功")
            })

            if mainDeckView.frame.origin.x > self.menuView.frame.width / 2 {
                isMenuOpen = true
                openMenu()
            } else {
                mainDeckBlurView.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.mainDeckBlurView.backgroundColor = .none
                    //                    self.topBackBlurView.backgroundColor = .none
                    //                    self.bottomBackBlurView.backgroundColor = .none

                    self.mainDeckBlurView.frame.origin.x = 0
                    self.mainDeckView.frame.origin.x = 0
                    self.bottomBackView.frame.origin.x = 0
                    self.topBackView.frame.origin.x = 0

                    self.menuView.frame.origin.x = -self.menuView.frame.width
                })
            }
        }
        // reset
        sender.setTranslation(CGPoint.zero, in: view)
    }
}
