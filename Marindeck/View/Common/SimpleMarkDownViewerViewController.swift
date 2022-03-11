import UIKit
import MarkdownView

final class SimpleMarkDownViewerViewController: UIViewController {
    var markdownView = MarkdownView()
    var textView = UITextView()
    var markdown: String = ""

    init(markdown: String) {
        super.init(nibName: nil, bundle: nil)

        self.markdown = markdown
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondaryBackgroundColor

        let subbg = "#\(UIColor.backgroundColor.toHexString())"
        let sublb = "#\(UIColor.subLabelColor.toHexString())"
        let lb = "#\(UIColor.labelColor.toHexString())"

        markdownView.load(
            markdown: markdown,
            css: "body {color:#\(UIColor.labelColor.toHexString());}\n pre{background: \(subbg);border: unset} \n .hljs{background-color: \(subbg); color:\(sublb)} \n .hljs-keyword{color:\(lb)}")
        markdownView.frame = view.bounds
        markdownView.webView?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 94, right: 0)
        view.addSubview(markdownView)

        markdownView.translatesAutoresizingMaskIntoConstraints = false
        markdownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        markdownView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        markdownView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        markdownView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setSwipeBack()
    }

}
