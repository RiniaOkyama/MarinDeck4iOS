//
//  CustomJSViewController.swift
//  Marindeck
//
//  Created by Rinia on 2021/04/12.
//

import UIKit


class CustomJSViewController: UIViewController {
    private lazy var dbQueue = Database.shared.dbQueue
    private var customJSs: [CustomJS] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateCustomJSs()

        view.backgroundColor = .backgroundColor

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "CustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "CustomAddCellTableViewCell", bundle: nil), forCellReuseIdentifier: "addCell")

        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let bvc = presentingViewController?.presentingViewController as? ViewController
//        bvc?.webView.reload()
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    func updateCustomJSs() {
        customJSs = fetchCustomJSs().sorted(by: { $0.loadIndex > $1.loadIndex })
    }

    func fetchCustomJSs() -> [CustomJS] {
        try! dbQueue.read { db in
            try CustomJS.fetchAll(db)
        }
    }

    func createCustomJS(customJS: CustomJS) {
        try! dbQueue.write { db in
            try customJS.insert(db)
        }
        updateCustomJSs()

        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    func deleteCustomJS(index: Int) {

        let _ = try! dbQueue.write { db in
            try customJSs[index].delete(db)
        }

        updateCustomJSs()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func updateCustomJS(index: Int, customJS: CustomJS) {

        try! dbQueue.write { db in
            try customJS.update(db)
        }

        updateCustomJSs()
        tableView.reloadData()
    }


    func updateCustomJSDialog(index: Int) {
        var alertTextField: UITextField?
        var customJS = customJSs[index]

        let alert = UIAlertController(
                title: "カスタムJS名を編集",
                message: "",
                preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
                configurationHandler: { (textField: UITextField!) in
                    textField.text = customJS.title
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
                        customJS.createAt = Date()
                        customJS.title = text
                        self.updateCustomJS(index: index, customJS: customJS)

                    }
                }
        )

        present(alert, animated: true, completion: nil)
    }

}


extension CustomJSViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customJSs.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if customJSs.count == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! CustomAddCellTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
            cell.selectionStyle = .none
            let customJS = customJSs[indexPath.row]
            cell.titleLabel.text = customJS.title
            cell.dateLabel.text = customJS.createAt.offsetFrom()

            return cell
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        customJSs.count != indexPath.row
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: 入れ替え時の処理を実装する（データ制御など）
    }


    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }

    // 編集モード時に左にずれるか。
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false //ずれない。
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if customJSs.count == indexPath.row {
            return
        }

        let vc = EditCustomJSViewController(customJS: customJSs[indexPath.row])
//        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if customJSs.count == indexPath.row {
            return nil
        }
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil"), identifier: nil) { action in
                self.updateCustomJSDialog(index: indexPath.row)
            }

            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
                print("indexPath is ", indexPath)
                self.deleteCustomJS(index: indexPath.row)
            }
            return UIMenu(title: "", image: nil, identifier: nil, children: [edit, delete])
        }
        return configuration
    }


}

extension CustomJSViewController: CustomAddCellOutput {
    // TODO
    func create() {
        var alertTextField: UITextField?

        let alert = UIAlertController(
                title: "カスタムJSを作成",
                message: "作成するカスタムJSにタイトルを付けてください",
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
                        // FIXME
                        let cjs = CustomJS(title: text, js: "", createAt: Date(), updateAt: Date(), loadIndex: Int32(self.customJSs.count), isLoad: true)
                        self.createCustomJS(customJS: cjs)
                        let vc = EditCustomJSViewController(customJS: cjs)
//                    vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
        )

        present(alert, animated: true, completion: nil)
    }

}
