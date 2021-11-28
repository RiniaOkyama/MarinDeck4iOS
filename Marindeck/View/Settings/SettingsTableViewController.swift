//
//  SettingsTableViewController.swift
//  Marindecker
//
//  Created by Rinia on 2021/01/16.
//

import UIKit
import WebKit
import UniformTypeIdentifiers //  iOS14~
import MobileCoreServices     // ~iOS13
import StoreKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var titleLabel: [UILabel] = []
    @IBOutlet weak var logoutLabel: UILabel!
        
    @IBOutlet weak var biometricsSwitch: UISwitch!
    @IBOutlet weak var nativeTweetModalSwitch: UISwitch!
    @IBOutlet weak var marginSafeAreaSwitch: UISwitch!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    
    private var dController: UIDocumentInteractionController!
    private let dbQueue = Database.shared.dbQueue

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Settings.Navigation.title
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(self.onDismiss))
        
        titleLabel.forEach({
            $0.textColor = .labelColor
            $0.text = $0.text?.localized ?? ""
        })
        
        appVersionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        logoutLabel.text = L10n.Settings.Logout.Cell.title
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)

        navigationController?.navigationBar.tintColor = .labelColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelColor]
        view.backgroundColor = .secondaryBackgroundColor
        navigationController?.navigationBar.backgroundColor = .secondaryBackgroundColor

        titleLabel.forEach({
            $0.textColor = .labelColor
        })
        tableView.reloadData()
        
        biometricsSwitch.setOn(UserDefaults.standard.bool(forKey: UserDefaultsKey.isUseBiometrics), animated: false)
        
        nativeTweetModalSwitch.setOn(UserDefaults.standard.bool(forKey: UserDefaultsKey.isNativeTweetModal), animated: false)
        
        marginSafeAreaSwitch.setOn(UserDefaults.standard.bool(forKey: UserDefaultsKey.marginSafeArea), animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentingViewController?.endAppearanceTransition()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }

    @objc func onDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .subLabelColor
            var headerTitle = ""
            switch (section) {
            case 0:
                headerTitle = L10n.Settings.General.Header.title
            case 1:
                headerTitle = L10n.Settings.Customize.Header.title
            case 2:
                headerTitle = L10n.Settings.Appinfo.Header.title
            case 4:
                headerTitle = L10n.Settings.Logout.Header.title
            default:
                break
            }
            headerView.textLabel?.text = headerTitle
        }
    }
    
    //Headerの高さ
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    //Footerの高さ
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        switch indexPath {
        case IndexPath(row: 2, section: 1):
            presentTheme()
        case IndexPath(row: 3, section: 1):
            presentActionButton()
        case IndexPath(row: 0, section: 2):
            termsOfUse()
        case IndexPath(row: 1, section: 2):
            license()
        case IndexPath(row: 2, section: 2):
            issue()
        case IndexPath(row: 3, section: 2):
            developers()
        case IndexPath(row: 5, section: 2):
            checkUpdate()
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
    
    @IBAction func setBiometrics() {
        UserDefaults.standard.setValue(biometricsSwitch.isOn, forKey: UserDefaultsKey.isUseBiometrics)
    }
    
    @IBAction func setNativeTweetModal() {
        UserDefaults.standard.setValue(nativeTweetModalSwitch.isOn, forKey: UserDefaultsKey.isNativeTweetModal)
    }
    
    @IBAction func setMarginSafeArea() {
        UserDefaults.standard.setValue(marginSafeAreaSwitch.isOn, forKey: UserDefaultsKey.marginSafeArea)
    }
    
    func presentTheme() {
        let vc = storyboard?.instantiateViewController(identifier: "Theme") as! ThemeViewController
        vc.viewController = presentingViewController as? ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentActionButton() {
        let vc = EditActionButtonViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func termsOfUse() {
        let path = Bundle.main.path(forResource: "TermsOfUse", ofType: "md")!
        let url = URL(fileURLWithPath: path)
        let markdown = try! String(contentsOf: url, encoding: String.Encoding.utf8)

        let vc = SimpleMarkDownViewerViewController(markdown: markdown)
        vc.title = L10n.Settings.TermsOfUse.Cell.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func license() {
        let path = Bundle.main.path(forResource: "license", ofType: "md")!
        let url = URL(fileURLWithPath: path)
        let markdown = try! String(contentsOf: url, encoding: String.Encoding.utf8)

        let vc = SimpleMarkDownViewerViewController(markdown: markdown)
        vc.title = L10n.Settings.License.Cell.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func issue() {
        openURL(url: "https://discord.gg/JKsqaxcnCW")
    }
    
    func developers() {
        openURL(url: "https://hisubway.online/articles/mddeveloper/")
    }
    
    func checkUpdate() {
        DispatchQueue.main.async {
            let loadingAlert: UIAlertController = .init(title: nil, message: "更新を確認中", preferredStyle: .alert)
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.center = CGPoint(x: 25, y: 30)
            loadingAlert.view.addSubview(indicator)
            
            indicator.startAnimating()
            self.present(loadingAlert, animated: true, completion: nil)
        
            Update.shared.checkForUpdate { [weak self] update in
                let alert = UIAlertController(title: update ? "アップデートがあります" : "最新です。", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
                if update {
                    alert.addAction(UIAlertAction(title: "更新", style: .default, handler: { _ in
                        DispatchQueue.main.async {
                            let url = URL(string: "itms-apps://itunes.apple.com/app/id\(Update.shared.appId)")!
                            UIApplication.shared.open(url)
                        }
                    }))
                }
                DispatchQueue.main.async {
                    loadingAlert.dismiss(animated: true) {
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    func openURL(url urlString: String) {
        if let url = URL(string: urlString) {
            let alert = UIAlertController(title: "URLを開きますか？", message: urlString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "開く", style: .default, handler: { _ in
                UIApplication.shared.open(url)
            }))
            alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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
        
        let cjss = try! dbQueue.read { db in
            try CustomJS.fetchAll(db)
        }

        if let jsdata = try? JSONEncoder().encode(cjss) {
            dict["customJSs"] = String(data: jsdata, encoding: .utf8)
        }
        
        let csss = try! dbQueue.read { db in
            try CustomCSS.fetchAll(db)
        }

        if let cssdata = try? JSONEncoder().encode(csss) {
            dict["customCSSs"] = String(data: cssdata, encoding: .utf8)
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
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { [weak self] records in
                dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {})
                
                let bvc = self?.presentingViewController as? ViewController
                bvc?.webView.reload()
            }
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
                } else if key == "customJSs" {
                    guard let dataString = value as? String else { continue }
                    guard let data = dataString.data(using: .utf8) else { continue }
                    guard let cjss: [CustomJS] = try? JSONDecoder().decode([CustomJS].self, from: data) else { continue }
                     
                    try! dbQueue.write { db in
                        cjss.forEach { try? $0.insert(db) }
                    }
                } else if key == "customCSSs" {
                    guard let dataString = value as? String else { continue }
                    guard let data = dataString.data(using: .utf8) else { continue }
                    guard let cjss: [CustomCSS] = try? JSONDecoder().decode([CustomCSS].self, from: data) else { continue }
                     
                    try! dbQueue.write { db in
                        cjss.forEach { try? $0.insert(db) }
                    }
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
