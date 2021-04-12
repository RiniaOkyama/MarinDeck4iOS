//
//  CustomJSViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/04/12.
//

import UIKit

struct CustomJS: Codable {
    var title:String
    var js:String
    var created_at: Date
}

class CustomJSViewController: UIViewController {
    private let userDefaults = UserDefaults.standard
    private var customJSs:[CustomJS] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCustomJSs()

        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "CustomJSCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "CustomJSAddCellTableViewCell", bundle: nil), forCellReuseIdentifier: "addCell")
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateCustomJSs() {
        customJSs = fetchCustomJSs().reversed()
    }
    
    func fetchCustomJSs() -> [CustomJS] {
        let jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        var retArray: [CustomJS] = []
        for item in jsonArray {
            let jsonData = item.data(using: .utf8)!
            retArray.append(try! JSONDecoder().decode(CustomJS.self, from: jsonData))
        }
        return retArray
    }
    
    func createCustomJS(customJS: CustomJS) {
        var jsonArray: [String] = userDefaults.array(forKey: UserDefaultsKey.customJSs) as? [String] ?? []
        let jsonData = try! JSONEncoder().encode(customJS)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        jsonArray.append(jsonString)
        userDefaults.set(jsonArray, forKey: UserDefaultsKey.customJSs)
        
        updateCustomJSs()
        self.tableView.reloadData()
    }
    
}


extension CustomJSViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customJSs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if customJSs.count == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! CustomJSAddCellTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomJSCellTableViewCell
            cell.selectionStyle = .none
            let customJS = customJSs[indexPath.row]
            cell.titleLabel.text = customJS.title
            cell.dateLabel.text = customJS.created_at.offsetFrom()

            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if customJSs.count == indexPath.row { return }
        
        let vc = EditCustomJSViewController(index: indexPath.row)
//        vc.modalPresentationStyle = .overFullScreen
        self.present(vc,animated: true,completion: nil)
    }
     
    
    
}

extension CustomJSViewController: CustomJSAddCellOutput {
    // TODO
    func create() {
        var alertTextField: UITextField?

         let alert = UIAlertController(
             title: "Create Custom JS",
             message: "Enter new title",
             preferredStyle: UIAlertController.Style.alert)
         alert.addTextField(
             configurationHandler: {(textField: UITextField!) in
                 alertTextField = textField
//                 textField.text = self.label1.text
         })
         alert.addAction(
             UIAlertAction(
                 title: "Cancel",
                 style: UIAlertAction.Style.cancel,
                 handler: nil))
         alert.addAction(
             UIAlertAction(
                 title: "OK",
                 style: UIAlertAction.Style.default) { _ in
                 if let text = alertTextField?.text {
                    // FIXME
                    self.createCustomJS(customJS: CustomJS(title: text, js: "", created_at: Date()))
                    let vc = EditCustomJSViewController(index: 0)
//                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc,animated: true,completion: nil)
                 }
             }
         )

         self.present(alert, animated: true, completion: nil)
     }
    
}
