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

        title = "CustomJS"

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
        customJSs = fetchCustomJSs().sorted(by: { $0.loadIndex < $1.loadIndex })
        print("customJS: ", customJSs)
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
        tableView.insertRows(at: [IndexPath(row: customJSs.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    func deleteCustomJS(index: Int) {

        let _ = try! dbQueue.write { db in
            try customJSs[index].delete(db)
        }

        updateCustomJSs()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func updateCustomJS(customJS: CustomJS, isReload: Bool = true) {

        try! dbQueue.write { db in
            try customJS.update(db)
        }

        if isReload {
            updateCustomJSs()
            tableView.reloadData()
        }
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
                        self.updateCustomJS(customJS: customJS)

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

        customJSs.move(fromOffsets: IndexSet(integer: sourceIndexPath.row), toOffset: destinationIndexPath.row)

        for i in 1...customJSs.count {
            var tmpJs = customJSs[i - 1]
            tmpJs.loadIndex = Int32(i)
            updateCustomJS(customJS: tmpJs, isReload: false)
        }

        updateCustomJSs()
        tableView.reloadData()
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
        navigationController?.pushViewController(vc, animated: true)
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
                        let cjs = CustomJS(title: text, js: "", createAt: Date(), updateAt: Date(), loadIndex: Int32(self.customJSs.count + 1), isLoad: true)
                        self.createCustomJS(customJS: cjs)
                        let vc = EditCustomJSViewController(customJS: self.customJSs.last!)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
        )

        present(alert, animated: true, completion: nil)
    }

}
