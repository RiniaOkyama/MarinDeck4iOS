//
//  TweetView.swift
//  Marindeck
//
//  Created by a on 2022/03/11.
//

import UIKit

class TweetView: UIView {
    @IBOutlet private weak var avatarImageButton: UIButton!
    @IBOutlet private weak var smallModeButton: UIButton!
    @IBOutlet private weak var tweetTextView: UITextView!
    @IBOutlet private weak var tweetTextViewConstraint: NSLayoutConstraint!
    @IBOutlet private var marginConstraints: [NSLayoutConstraint]!

    private var keyboardHeight: CGFloat = 0
    private var isSmall = false
    
    private let normalTweetModalHeight: CGFloat = 128
    private let smallTweetModalHeight: CGFloat = 50
    
    init() {
        super.init(frame: .zero)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchEvent = touches.first!

        let preDy = touchEvent.previousLocation(in: self).y
        let newDy = touchEvent.location(in: self).y

        let dy = newDy - preDy

        frame.origin.y += dy
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       touchUp()
    }
    
    func touchUp() {
        if isSmall ? frame.origin.y > UIScreen.main.bounds.height - keyboardHeight - 150 : frame.origin.y > 150 {
            isSmall = true
            avatarImageButton.isEnabled = false
            UIView.animate(withDuration: 0.1) {
                self.frame.origin.y = UIScreen.main.bounds.height - self.keyboardHeight - self.smallTweetModalHeight
                self.frame.size.height = self.smallTweetModalHeight
                self.layer.cornerRadius = 4
                self.marginConstraints.forEach { $0.constant = 4 }
                self.tweetTextViewConstraint.constant = self.smallTweetModalHeight - 8
            }
        } else {
            isSmall = false
            avatarImageButton.isEnabled = true
            UIView.animate(withDuration: 0.1) {
                self.frame.origin.y = 40
                self.frame.size.height = 150
                self.layer.cornerRadius = 12
                self.marginConstraints.forEach { $0.constant = 12 }
                self.tweetTextViewConstraint.constant = self.normalTweetModalHeight
            }
        }
    }
    
//    func doAnimation(small: Bool) {
//
//        if small {
//            UIView.animateWithDuration(
//                 0.5,
//                 delay:0.3,
//                 options:UIViewAnimationOptions.CurveEaseOut,
//                 animations: {() -> Void in
//                     // これが大事!
//                     self.view.layoutIfNeeded()
//                 },
//                 completion: nil
//             );
//        } else {
//
//        }
//    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("TweetView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        setupViews()
    }
    
    func setupViews() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        clipsToBounds = true
        layer.cornerRadius = 12
        
        avatarImageButton.contentMode = .scaleAspectFit
        avatarImageButton.layer.cornerRadius = avatarImageButton.frame.width / 2
        avatarImageButton.clipsToBounds = true
        avatarImageButton.setTitle("", for: .normal)
        
        smallModeButton.setTitle("", for: .normal)
        
        tweetTextView.textContainerInset = .zero
        tweetTextView.sizeToFit()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            if isSmall {
                frame.origin.y = UIScreen.main.bounds.height - keyboardHeight - smallTweetModalHeight
            }
        }
    }


}
