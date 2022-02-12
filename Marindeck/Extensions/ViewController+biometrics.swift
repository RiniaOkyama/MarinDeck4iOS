//
// Created by a on 2022/01/26.
//

import Foundation
import UIKit
import LocalAuthentication

extension ViewController {
    // 生体認証
    func checkBiometrics() {
        let isUseBiometrics = UserDefaults.standard.bool(forKey: UserDefaultsKey.isUseBiometrics)
        if isUseBiometrics {
            if canUseBiometrics() {
                isMainDeckViewLock = true
                mainDeckView.isHidden = true
                let context = LAContext()
                let reason = "ロックを解除"
                let backBlackView = UIView(frame: view.bounds)
                backBlackView.backgroundColor = .black
                view.addSubview(backBlackView)
                context.evaluatePolicy(.deviceOwnerAuthentication,
                                       localizedReason: reason) { (success, evaluateError) in
                    if success {
                        DispatchQueue.main.async { [unowned self] in
                            self.isMainDeckViewLock = false
                            self.mainDeckView.isHidden = false
                            self.tweetFloatingBtn.isHidden = false
                            UIView.animate(withDuration: 0.3, animations: {
                                backBlackView.alpha = 0
                            }, completion: { _ in
                                backBlackView.removeFromSuperview()
                            })
                        }
                    } else {
                        DispatchQueue.main.async {
                            let errorLabel = UILabel(frame: backBlackView.bounds)
                            errorLabel.textAlignment = .center
                            errorLabel.text = "認証に失敗しました。"
                            errorLabel.textColor = .white
                            backBlackView.addSubview(errorLabel)
                        }
                        guard let error = evaluateError as NSError? else {
                            print("Error")
                            return
                        }
                        print("\(error.code): \(error.localizedDescription)")
                    }
                }
            } else {
                // 生体認証をオンにしているが、許可されていない。
            }
        }
    }
}
