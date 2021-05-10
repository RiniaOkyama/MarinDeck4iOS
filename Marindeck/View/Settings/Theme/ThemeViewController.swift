//
//  ThemeViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/05/06.
//

import UIKit

class ThemeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var viewController: ViewController!
    var applyID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "着せ替え"
                        
        updateApplyID()
        
        tableView.register(UINib(nibName: "ThemeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadColor()
        updateApplyID()
        tableView.reloadData()
    }
    
    func reloadColor() {
        navigationController?.navigationBar.tintColor = .labelColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.labelColor]
        view.backgroundColor = .secondaryBackgroundColor
        tableView.backgroundColor = .secondaryBackgroundColor
    }
    
    func updateApplyID() {
        applyID = UserDefaults.standard.string(forKey: UserDefaultsKey.themeID) ?? "0"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThemeTableViewCell
        
        let theme = themes[indexPath.row]
        cell.titleLabel.text = theme.title
        cell.descriptionLabel.text = theme.description
        
        cell.titleLabel.textColor = .labelColor
        cell.descriptionLabel.textColor = .labelColor
        cell.backView.backgroundColor = .backgroundColor
        cell.applyButton.setTitleColor(.labelColor, for: .normal)
        cell.applyButton.tintColor = .labelColor
        cell.applyButton.backgroundColor = .secondaryBackgroundColor
        cell.tag = indexPath.row
        cell.delegate = self

        if applyID == theme.id{
            cell.applyButton.setTitle("適用済", for: .normal)
            cell.applyButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.applyButton.backgroundColor = .secondaryBackgroundColor
        }else {
            cell.applyButton.setTitle("適用", for: .normal)
            cell.applyButton.backgroundColor = .systemTeal // teal
            cell.applyButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "Detail") as! ThemeDetailViewController
        vc.theme = themes[indexPath.row]
        vc.viewController = viewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ThemeViewController: ThemeTableViewCellDelegate {
    func apply(tag: Int) {
        let id = themes[tag].id
        if applyID == id { return }
        UserDefaults.standard.setValue(id, forKey: UserDefaultsKey.themeID)
        viewController.webView.reload()
        updateApplyID()
        tableView.reloadData()
        reloadColor()
    }
}
