//
//  TermsOfUseViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/05/11.
//

import UIKit
import SwiftyMarkdown

class TermsOfUseViewController: UIViewController {
//    @IBOutlet weak var markDownTextView: MarkDownTextView!
    @IBOutlet weak var textView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadText()
    }
    
    
    func loadText() {
        self.textView.dataDetectorTypes = UIDataDetectorTypes.all
        
        if let url = Bundle.main.url(forResource: "TermsOfUse", withExtension: "md"), let md = SwiftyMarkdown(url: url) {
//            md.h2.fontName = "AvenirNextCondensed-Bold"
//            md.h2.color = UIColor.blue
//            md.h2.alignment = .center
            
//            md.code.fontName = "CourierNewPSMT"
            

//            if #available(iOS 13.0, *) {
//                md.strikethrough.color = .tertiaryLabel
//            } else {
//                md.strikethrough.color = .lightGray
//            }
            
            md.blockquotes.fontStyle = .italic
        
            md.underlineLinks = true
            
            let attributedString = md.attributedString()
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 10
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 40
            let attributes = [NSAttributedString.Key.paragraphStyle : style]
//            textView.attributedText = NSAttributedString(string: textView.text,
//                                           attributes: attributes)
    
            
//            let mutableAttributedString = NSMutableAttributedString()
//            mutableAttributedString.append(attributedString)
//            mutableAttributedString.append(NSAttributedString(string: textView.text,
//                                                              attributes: attributes))
            
//            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
//
//            self.textView.attributedText =
//
//            let font = UIFont.systemFont(ofSize: 18) // or whatever font you use
//            textLabel.font = font
//            let attributedString = NSMutableAttributedString(string: "your text")
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 22 - 18 - (font.lineHeight - font.pointSize)
//            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            textView.attributedText = attributedString
//            textView.attributedText = mutableAttributedString
            textView.textContainer.lineFragmentPadding = 10

            

        } else {
            fatalError("Error loading file")
        }
    }
    
}
