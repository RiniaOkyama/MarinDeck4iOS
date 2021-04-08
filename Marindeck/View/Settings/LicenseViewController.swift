//
//  LicenseViewController.swift
//  Marindecker
//
//  Created by craptone on 2021/03/16.
//

import UIKit
import markymark


class LicenseViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    @IBOutlet weak var mdView: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var markDownView: UIView!
//    @IBOutlet weak var markDownView: MarkDownTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(scrollView)
        mdView.addSubview(scrollView)

        let markDownView = getMarkDownView()
        scrollView.addSubview(markDownView)
//        let mview = getMarkDownView()
//        mview.frame = markDownView.bounds
//        mview.frame.size.height = mview.view
//        self.markDownView.addSubview(mview)
//        self.markDownView.frame.size.height = mview.frame.height
        
        markDownView.text = getMarkDownString()
        
        
        scrollView.frame = mdView.frame
//        scrollView.frame.size.width = mdView.frame.width
        markDownView.frame.size.width = mdView.frame.width - 64
        markDownView.frame.size.height = 700

//        markDownView.backgroundColor = .blue
        let views: [String: Any] = [
            "view": mdView,
            "scrollView": scrollView,
            "markDownView": markDownView
        ]

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        markDownView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.contentInset          = UIEdgeInsets(top: 0.0, left: 0, bottom: 32, right: 0);
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 32, right: -16);


        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: [], metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[markDownView(==scrollView)]|", options: [], metrics: [:], views: views)
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[markDownView]-32-|", options: [], metrics: [:], views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[markDownView]|", options: [], metrics: [:], views: views)
        view.addConstraints(constraints)
        
//        markDownView.frame.size.width = 25
    }
    
    @IBAction func exit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getMarkDownView() -> MarkDownTextView {
        let markDownView = MarkDownTextView(markDownConfiguration: .view)

        //Styling. See README for more styling options
        markDownView.styling.paragraphStyling.textColor = .label
        markDownView.styling.headingStyling.textColorsForLevels = [
            .label, //H1 (i.e. # Title)
            .label,  //H2, ... (i.e. ## Subtitle, ### Sub subtitle)
            .label,
            .label
        ]
//        markDownView.styling.headingStyling.textColorsForLevels = [.orange, .black]
//        markDownView.styling.linkStyling.textColor = .blue
//        markDownView.styling.listStyling.bulletImages = [
//            UIImage(named: "circle"),
//            UIImage(named: "emptyCircle"),
//            UIImage(named: "line"),
//            UIImage(named: "square")
//        ]

        markDownView.styling.paragraphStyling.baseFont = .systemFont(ofSize: 14)

        markDownView.text = getMarkDownString()
        return markDownView
    }

    func getMarkDownString() -> String {
        return """
# License

## MIT License

The following component(s) are licensed under the MIT License reproduced below

* MTDeck, Copyright (c) 2021 mkizka
* Marky-Mark, Copyright (c) 2016 M2mobi
* Optik, Copyright (c) 2017 Prolific Interactive.

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

-----------

## Thanks!!!!

"""
    }

    


    
}
