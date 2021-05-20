//
//  SettingsTableViewController.swift
//  Marindecker
//
//  Created by craptone on 2021/01/16.
//

import UIKit
import WebKit
import UniformTypeIdentifiers // iOS14~
import MobileCoreServices // ~iOS13

class SettingsTableViewController: UITableViewController {
    @IBOutlet var titleLabel: [UILabel] = []
    
    private var dController: UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "設定"
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(self.onDismiss))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .labelColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelColor]
        self.view.backgroundColor = .secondaryBackgroundColor
        titleLabel.forEach({
            $0.textColor = .labelColor
        })
        tableView.reloadData()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    
    @objc func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .subLabelColor
        }
    }
    //Headerの高さ
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    //Footerの高さ
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // CustomJSはStoryboardの方から遷移操作してます。
        
        switch indexPath {
        case IndexPath(row: 2, section: 1):
            presentTheme()
        case IndexPath(row: 2, section: 2):
            issue()
        case IndexPath(row: 4, section: 2):
            donate()
        case IndexPath(row: 0, section: 3):
            importSettings()
        case IndexPath(row: 1, section: 3):
            exportSettings()
        case IndexPath(row: 0, section: 4):
            logout()
        default:
            break
        }
    }
    
    func presentTheme() {
        let vc = storyboard?.instantiateViewController(identifier: "Theme") as! ThemeViewController
        vc.viewController = presentingViewController as? ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func donate() {
        if let url = URL(string: "http://fantia.jp/hisubway") {
            UIApplication.shared.open(url)
        }
    }
    
    func issue() {
        if let url = URL(string: "https://discord.gg/JKsqaxcnCW") {
            UIApplication.shared.open(url)
        }
    }
    
    func importSettings() {
        if #available(iOS 14.0, *) {
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json], asCopy: true)
            picker.delegate = self
            self.navigationController?.present(picker, animated: true, completion: nil)
            
        }else {
            let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeJSON)], in: .import)
            picker.delegate = self
            self.navigationController?.present(picker, animated: true, completion: nil)
        }

    }
    
    func exportSettings() {
        let userdefaultsData = UserDefaults.standard.dictionaryRepresentation()
        
        var dict:[String: Any] = [:]
        for (key, value) in userdefaultsData {
            if UserDefaultsKey.allKeys.contains(key) {
                dict[key] = value
            }
        }
        
        guard let json = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        let data = String(data: json, encoding: .utf8)!
        
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("MarinDeckSettings.json")!
        do{
            try data.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            print("データ保存でエラー")
            return
        }

        dController = UIDocumentInteractionController.init(url: url)
        if !(dController.presentOpenInMenu(from: view.frame, in: self.view, animated: true)) {
            print("ファイルに対応するアプリがない")
        }
    }
    
    func logout() {
        let alert: UIAlertController = UIAlertController(title: "ログアウト", message: "先にいってしまうでござるか", preferredStyle:  .alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "ログアウト", style: .destructive, handler:{
            (action: UIAlertAction!) -> Void in
            
            URLSession.shared.reset {}
            UserDefaults.standard.synchronize()
            let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {})
            }
            
            let bvc = self.presentingViewController as? ViewController
            bvc?.webView.reload()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
            (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        present(alert, animated: true, completion: nil)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

//        cell.selectionStyle = .none
        cell.backgroundColor = .backgroundColor
        cell.textLabel?.textColor = .red
        cell.contentView.backgroundColor = .backgroundColor
//        cell.backgroundView?.backgroundColor = .yellow

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// ~iOS13
extension SettingsTableViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let filePath = urls.first {
            print("ファイルパス:\(filePath)")
            
            let fileData = try! Data(contentsOf: filePath);
            
            let dict:[String: Any] = try! JSONSerialization.jsonObject(with: fileData, options: []) as? [String: Any] ?? [:]
            for (key, value) in dict {
                if UserDefaultsKey.allKeys.contains(key) {
                    UserDefaults.standard.setValue(value, forKey: key)
                }
            }
            
            let alert: UIAlertController = UIAlertController(title: "設定をインポートしました。", message: "アプリ再起動をおすすめします。", preferredStyle:  .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler:{
                (action: UIAlertAction!) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })

            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("キャンセル")
    }
}
