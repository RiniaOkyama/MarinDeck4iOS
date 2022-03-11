//
//  AppDebugView.swift
//  Marindeck
//
//  Created by a on 2022/03/11.
//

import SwiftUI

struct AppDebugView: View {
    @Environment(\.presentationMode) var presentationMode
    weak var vc: UIViewController? = nil
    
    init(vc: UIViewController? = nil) {
        self.vc = vc
    }

    var body: some View {
        VStack(spacing: 32) {
            Button("AppDebugモードを終了", action: {
                UserDefaults.standard.set(false, forKey: .appDebugMode)
                presentationMode.wrappedValue.dismiss()
            })
            Button("Deckを表示", action: {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
                self.vc?.present(vc, animated: false, completion: nil)
            })
            Button("設定を表示", action: {
                let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as! SettingsTableViewController
                let nvc = UINavigationController(rootViewController: vc)
                self.vc?.present(nvc, animated: true, completion: nil)
            })
            Button("Twitter設定画面", action: {
                vc?.present(TwitterSettingsViewController(), animated: true, completion: nil)
            })
            
            Button("OnBoardingを表示", action: {
                let onBoardingVC = OnBoardingViewController()
                onBoardingVC.modalPresentationStyle = .currentContext
                vc?.present(onBoardingVC, animated: false, completion: nil)
            })
            
            Button("ネイティブTweetModal", action: {
                let vc = UIViewController()
                vc.modalPresentationStyle = .overFullScreen
                let view = TweetView()
                view.frame = vc.view.bounds
                view.frame.origin.y = 40
                view.frame.size.height = 150
                vc.view.addSubview(view)
                vc.view.backgroundColor = .clear
                self.vc?.present(vc, animated: false, completion: nil)
            })
        }
    }
}

struct AppDebugView_Previews: PreviewProvider {
    static var previews: some View {
        AppDebugView()
    }
}
