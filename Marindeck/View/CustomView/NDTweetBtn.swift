//
//  NDTweetBtn.swift
//  NDTweetBtn
//
//  Created by NDSLib on 2021/04/21.
//
//  MIT License

import UIKit
import AudioToolbox

fileprivate extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@available(iOS 13.0, *)
public class NDActionButton: UIView {
    public lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4

        layer.cornerRadius = frame.width / 2
        addSubview(imageView)
    }

    public func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
}

public class NDTweetBtnAction {
    let image: UIImage
    let handler: (NDTweetBtnAction) -> Void?

    public init(image: UIImage, handler: @escaping (NDTweetBtnAction) -> Void?) {
        self.image = image
        self.handler = handler
    }
}


@available(iOS 13.0, *)
@IBDesignable
public class NDTweetBtn: UIView {
    private var isPressing = false {
        didSet {
            AudioServicesPlaySystemSound(1519)
            if isPressing {
                onPressing()
            } else {
                onRelease()
            }
        }
    }

    public lazy var baseButton: NDActionButton = {
        let view = NDActionButton(frame: bounds)
        view.backgroundColor = UIColor(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPressed))
        longPress.minimumPressDuration = 0.3
        view.addGestureRecognizer(longPress)
        return view
    }()

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    public lazy var actionBtn1: NDActionButton = {
        let view = NDActionButton(frame: bounds)
        view.frame.origin.x -= 90
        view.frame.origin.y -= 90
        view.backgroundColor = UIColor(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
        view.tag = 1
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onActionBtnPressed))
        view.addGestureRecognizer(ges)
        return view
    }()

    public lazy var actionBtn2: NDActionButton = {
        let view = NDActionButton(frame: bounds)
        view.frame.origin.x -= 120
        view.frame.origin.y -= 10
        view.backgroundColor = UIColor(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
        view.tag = 2
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onActionBtnPressed))
        view.addGestureRecognizer(ges)
        return view
    }()

    public lazy var actionBtn0: NDActionButton = {
        let view = NDActionButton(frame: bounds)
        view.frame.origin.x -= 0
        view.frame.origin.y -= 130
        view.backgroundColor = UIColor(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
        view.tag = 0
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onActionBtnPressed))
        view.addGestureRecognizer(ges)
        return view
    }()

    private var actions: [NDTweetBtnAction] = []
    private var selectedIndex: Int?
    private var isInBaseBtn: Bool = false
    private var baseBtnImg: UIImage!

    public var tapped: (() -> Void?)?

    public override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(baseButton)

        if actions.count == 0 {
            let btns = [actionBtn0, actionBtn1, actionBtn2]
                    .forEach {
                $0.isHidden = true
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        baseButton.imageView.frame.size = CGSize(width: 20, height: 20)
        baseButton.imageView.center = baseButton.center

        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 0.1
        animation.toValue = self.baseButton.bounds.width / 2
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        baseButton.layer.add(animation, forKey: nil)

        UIView.animate(withDuration: 0.1, animations: {
            self.baseButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
        })
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPressing {
            let touch = touches.first!
            let location = touch.location(in: self.baseButton)
            if self.baseButton.bounds.contains(location) {
                tapped?()
            }
            baseBtnTouchUp()
            
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPressing {
            isPressing = !isPressing
        }else {
            let touch = touches.first!
            let location = touch.location(in: self.baseButton)
            if self.baseButton.bounds.contains(location) {
                tapped?()
            }
            baseBtnTouchUp()
        }
    }
    
    private func baseBtnTouchUp() {
        baseButton.imageView.frame.size = CGSize(width: 30, height: 30)
        baseButton.imageView.center = baseButton.center

        UIView.animate(withDuration: 0.1, animations: {
            self.baseButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in })
    }

    public func setImage(_ image: UIImage) {
        baseBtnImg = image
        baseButton.setImage(image)
    }

    public func addAction(action: NDTweetBtnAction) {
        actions.append(action)

        if actions.count > 3 {
            fatalError("action button is max 3 items")
        }
        // FIXME
        var btns = [actionBtn0, actionBtn1, actionBtn2]
        for (index, item) in actions.enumerated() {
            btns[index].isHidden = false
            btns[index].setImage(item.image)
        }
        btns.removeSubrange(0...actions.count - 1)
        btns.forEach {
            $0.isHidden = true
        }
    }

    @objc func onActionBtnPressed(sender: UITapGestureRecognizer) {
        actions[safe: sender.view!.tag]?.handler(actions[sender.view!.tag])
        isPressing = false
    }

    @objc func onLongPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            isPressing = !isPressing
            isInBaseBtn = true
        } else if sender.state == .changed {
            let pos = sender.location(in: baseButton)
            isInBaseBtn = pos.x > 0 && pos.x < baseButton.frame.width && pos.y > 0 && pos.y < baseButton.frame.height
            if isInBaseBtn {
                return
            }
            var actionBtns = [actionBtn0, actionBtn1, actionBtn2]
            
            guard let actionIndex = whichActionBtn(point: pos) else {
                selectedIndex = nil
                UIView.animate(withDuration: 0.1, animations: {
                    actionBtns.forEach({ $0.transform = CGAffineTransform(scaleX: 1, y: 1) })
                })
                return
            }
            if selectedIndex != actionIndex {
                AudioServicesPlaySystemSound(1519)
            }
            selectedIndex = actionIndex
            
            UIView.animate(withDuration: 0.1, animations: {
                actionBtns[actionIndex].transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
            actionBtns.remove(at: actionIndex)
            UIView.animate(withDuration: 0.1, animations: {
                actionBtns.forEach({ $0.transform = CGAffineTransform(scaleX: 1, y: 1) })
            })
        } else if sender.state == .ended {
            [self.actionBtn1, self.actionBtn2, self.actionBtn0]
                    .forEach {
                $0.transform = CGAffineTransform(scaleX: 1, y: 1)
            }

            if !isInBaseBtn {
                isPressing = false

                if let index = selectedIndex {
                    actions[safe: index]?.handler(actions[index])
                }
            }

        }
    }

    private func onPressing() {
        baseButton.backgroundColor = .white
        baseButton.setImage(UIImage(systemName: "xmark")!)
        baseButton.imageView.tintColor = .darkGray
        baseButton.imageView.frame.size = CGSize(width: 20, height: 20)
        baseButton.imageView.center = baseButton.center

        selectedIndex = nil

        [self.actionBtn1, self.actionBtn2, self.actionBtn0]
                .forEach {
            $0.frame = baseButton.bounds
            $0.alpha = 1
            addSubview($0)
        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 0.1
        animation.toValue = self.baseButton.bounds.width / 2
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        baseButton.layer.add(animation, forKey: nil)

        UIView.animate(withDuration: 0.1, animations: {
            self.actionBtn1.frame.origin = self.baseButton.frame.insetBy(dx: -90, dy: -90).origin
            self.actionBtn2.frame.origin = self.baseButton.frame.insetBy(dx: -120, dy: -10).origin
            self.actionBtn0.frame.origin = self.baseButton.frame.insetBy(dx: -5, dy: -130).origin
            self.baseButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
        })

    }

    private func onRelease() {
        baseButton.backgroundColor = UIColor(red: 0.16, green: 0.62, blue: 0.95, alpha: 1)
        baseButton.setImage(baseBtnImg ?? UIImage())
        baseButton.imageView.tintColor = .white
        baseButton.imageView.frame.size = CGSize(width: 30, height: 30)
        baseButton.imageView.center = baseButton.center

        UIView.animate(withDuration: 0.1, animations: {
            self.baseButton.transform = CGAffineTransform(scaleX: 1, y: 1)

            [self.actionBtn1, self.actionBtn2, self.actionBtn0]
                    .forEach {
                $0.frame = self.baseButton.bounds
                $0.alpha = 0
            }
        }, completion: { _ in
            self.actionBtn0.removeFromSuperview()
            self.actionBtn1.removeFromSuperview()
            self.actionBtn2.removeFromSuperview()
        })

    }

    private func whichActionBtn(point: CGPoint) -> Int? {
        if cgRect2AboutRect(self.actionBtn0.frame).contains(point) {
            return 0
        }else if cgRect2AboutRect(self.actionBtn1.frame).contains(point) {
            return 1
        }else if cgRect2AboutRect(self.actionBtn2.frame).contains(point) {
            return 2
        }else {
            return nil
        }
    }
    
    private func cgRect2AboutRect(_ rect: CGRect) -> CGRect {
        return CGRect(x: rect.origin.x - 40, y: rect.origin.y - 40, width: rect.size.width + 40, height: rect.size.height + 40)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isPressing { return super.hitTest(point, with: event) }
        let convertedactionBtn0: CGPoint = self.actionBtn0.convert(point, from: self)
        let convertedactionBtn1: CGPoint = self.actionBtn1.convert(point, from: self)
        let convertedactionBtn2: CGPoint = self.actionBtn2.convert(point, from: self)
        let convertedBaseButton: CGPoint = self.baseButton.convert(point, to: self)

        if self.actionBtn0.bounds.contains(convertedactionBtn0) {
            return self.actionBtn0.hitTest(convertedactionBtn0, with: event)
        }
        else if self.actionBtn1.bounds.contains(convertedactionBtn1) {
            return self.actionBtn1.hitTest(convertedactionBtn1, with: event)
        }
        else if self.actionBtn2.bounds.contains(convertedactionBtn2) {
            return self.actionBtn2.hitTest(convertedactionBtn2, with: event)
        }
        else if self.baseButton.bounds.contains(convertedBaseButton) {
//            return self.baseButton
        }
        else {
            isPressing = false
        }
        
        return super.hitTest(point, with: event)
//        return nil
    }


}
