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
        self.title = L10n.Settings.Theme.Cell.title
                        
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
        cell.descriptionLabel.text = theme.user
        
        cell.titleLabel.textColor = .labelColor
        cell.descriptionLabel.textColor = .subLabelColor
        cell.backView.backgroundColor = .backgroundColor
        cell.applyButton.setTitleColor(.labelColor, for: .normal)
        cell.applyButton.tintColor = .labelColor
        cell.applyButton.backgroundColor = .secondaryBackgroundColor
        cell.applyButton.setImage(UIImage(), for: .normal)
        cell.applyButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        cell.tag = indexPath.row
        cell.delegate = self
        cell.iconView.image = UIImage(named: theme.icon) ?? UIImage(named: "Marindeck_logo")

        if applyID == theme.id{
            cell.applyButton.setTitle("適用済", for: .normal)
//            cell.applyButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.applyButton.backgroundColor = .secondaryBackgroundColor
        }else {
            cell.applyButton.setTitle("適用", for: .normal)
            cell.applyButton.backgroundColor = .systemBlue
//            cell.applyButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.applyButton.setTitleColor(.white, for: .normal)
            cell.applyButton.tintColor = .white
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
