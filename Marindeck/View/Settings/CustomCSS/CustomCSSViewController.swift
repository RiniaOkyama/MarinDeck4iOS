//
//  CustomCSSViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/06/10
//

import UIKit
import RealmSwift


class CustomCSS: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var css: String = ""
    @objc dynamic var created_at: Date = Date()
}

class CustomCSSViewController: UIViewController {
    private let userDefaults = UserDefaults.standard
    private var realm = try! Realm()
    private var customCSSs: Results<CustomCSS>!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let bvc = self.presentingViewController?.presentingViewController as? ViewController
        bvc?.webView.reload()
    }

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateCustomCSSs() {
        customCSSs = realm.objects(CustomCSS.self)
        tableView.reloadData()
    }
    
    func createCustomCSS(customCSS: CustomCSS) {
        try! realm.write({
            realm.add(customCSS)
        })
        tableView.reloadData()
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
                    try! self.realm.write({
                        self.realm.delete(self.customCSSs[index])
                    })
                    self.tableView.reloadData()
                }
        )

        self.present(alert, animated: true, completion: nil)
    }
    
    
    func updateCustomCSSDialog(index: Int) {
        var alertTextField: UITextField?
        let customCSS = customCSSs[index]

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
                        try! self.realm.write({
                            customCSS.created_at = Date()
                            customCSS.title = text
                        })
                        self.updateCustomCSSs()
                    }
                }
        )

        self.present(alert, animated: true, completion: nil)
    }

}


extension CustomCSSViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customCSSs.count + 1
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
            cell.dateLabel.text = customCSS.created_at.offsetFrom()

            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if customCSSs.count == indexPath.row {
            return
        }

        let vc = EditCustomCSSViewController(customCSS: customCSSs[indexPath.row])
//        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
                        let customCSS = CustomCSS()
                        customCSS.title = text
                        self.createCustomCSS(customCSS: customCSS)

                        let vc = EditCustomCSSViewController(customCSS: customCSS)
//                    vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
        )

        self.present(alert, animated: true, completion: nil)
    }

}
