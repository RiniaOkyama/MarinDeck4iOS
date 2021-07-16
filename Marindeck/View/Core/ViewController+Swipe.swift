//
//  ViewController+Swipe.swift
//  Marindecker
//
//  Created by craptone on 2021/03/15.
//

import Foundation
import UIKit

struct SwipeStruct {
    var isMenuCloseRight: Bool = false
    var isFirstTouch: Bool = false

}

extension ViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeStruct.isFirstTouch = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMenuOpen {
            return
        }

        let touchevent = touches.first!
        let view = touchevent.view!
        let old = touchevent.previousLocation(in: self.view)
        let new = touchevent.location(in: self.view)

        let move_x = new.x - old.x
        let move_y = new.y - old.y


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
}
