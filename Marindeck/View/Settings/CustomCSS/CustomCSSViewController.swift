//
//  CustomCSSViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/06/10
//

import UIKit


class CustomCSSViewController: UIViewController {
    private lazy var dbQueue = Database.shared.dbQueue
    private var customCSSs: [CustomCSS] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CustomCSS"

        updateCustomCSSs()

        view.backgroundColor = .backgroundColor

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "CustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "CustomAddCellTableViewCell", bundle: nil), forCellReuseIdentifier: "addCell")


    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let bvc = presentingViewController?.presentingViewController as? ViewController
//        bvc?.webView.reload()
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    func updateCustomCSSs() {
        customCSSs = fetchCustomCSSs().sorted(by: { $0.loadIndex < $1.loadIndex })
    }

    func fetchCustomCSSs() -> [CustomCSS] {
        try! dbQueue.read { db in
            try CustomCSS.fetchAll(db)
        }
    }

    func createCustomCSS(customCSS: CustomCSS) {
        try! dbQueue.write { db in
            try customCSS.insert(db)
        }

        updateCustomCSSs()
        tableView.insertRows(at: [IndexPath(row: customCSSs.count - 1, section: 0)], with: .automatic)
    }

    func deleteCustomCSS(index: Int) {
        let alert = UIAlertController(
                title: "\(customCSSs[index].title)を消去",
                message: "本当に削除しますか？",
                preferredStyle: UIAlertController.Style.alert)
        alert.addAction(
                UIAlertAction(
                        title: "キャンセル",
                        style: UIAlertAction.Style.cancel,
                        handler: nil))
        alert.addAction(
                UIAlertAction(
                        title: "消去",
                        style: UIAlertAction.Style.destructive) { _ in
                    let _ = try! self.dbQueue.write { db in
                        try self.customCSSs[index].delete(db)
                    }
                    self.updateCustomCSSs()
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
        )

        present(alert, animated: true, completion: nil)
    }


    func updateCustomCSSDialog(index: Int) {
        var alertTextField: UITextField?
        var customCSS = customCSSs[index]

        let alert = UIAlertController(
                title: "カスタムCSS名を編集",
                message: "",
                preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
                configurationHandler: { (textField: UITextField!) in
                    textField.text = customCSS.title
                    alertTextField = textField
                })
        alert.addAction(
                UIAlertAction(
                        title: "キャンセル",
                        style: UIAlertAction.Style.cancel,
                        handler: nil))
        alert.addAction(
                UIAlertAction(
                        title: "変更する",
                        style: UIAlertAction.Style.default) { _ in
                    if let text = alertTextField?.text {
                        customCSS.updateAt = Date()
                        customCSS.title = text

                        try! self.dbQueue.write { db in
                            try customCSS.update(db)
                        }

                        self.updateCustomCSSs()
                        self.tableView.reloadData()
                    }
                }
        )

        present(alert, animated: true, completion: nil)
    }

}


extension CustomCSSViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customCSSs.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if customCSSs.count == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! CustomAddCellTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
            cell.selectionStyle = .none
            let customCSS = customCSSs[indexPath.row]
            cell.titleLabel.text = customCSS.title
            cell.dateLabel.text = customCSS.createAt.offsetFrom()

            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if customCSSs.count == indexPath.row {
            return
        }

        let vc = EditCustomCSSViewController(customCSS: customCSSs[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if customCSSs.count == indexPath.row {
            return nil
        }
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil"), identifier: nil) { action in
                self.updateCustomCSSDialog(index: indexPath.row)
            }

            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
                print("indexPath is ", indexPath)
                self.deleteCustomCSS(index: indexPath.row)
            }
            return UIMenu(title: "", image: nil, identifier: nil, children: [edit, delete])
        }
        return configuration
    }


}

extension CustomCSSViewController: CustomAddCellOutput {
    func create() {
        var alertTextField: UITextField?

        let alert = UIAlertController(
                title: "カスタムCSSを作成",
                message: "作成するカスタムCSSにタイトルを付けてください",
                preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
                configurationHandler: { (textField: UITextField!) in
                    alertTextField = textField
//                 textField.text = self.label1.text
                })
        alert.addAction(
                UIAlertAction(
                        title: "キャンセル",
                        style: UIAlertAction.Style.cancel,
                        handler: nil))
        alert.addAction(
                UIAlertAction(
                        title: "作成",
                        style: UIAlertAction.Style.default) { _ in
                    if let text = alertTextField?.text {
                        let customCSS = CustomCSS(id: nil, title: text, css: "", createAt: Date(), updateAt: Date(), loadIndex: Int32(self.customCSSs.count), isLoad: true)

                        self.createCustomCSS(customCSS: customCSS)

                        let vc = EditCustomCSSViewController(customCSS: self.customCSSs.last!)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
        )

        present(alert, animated: true, completion: nil)
    }

}
