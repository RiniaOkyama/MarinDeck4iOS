//
//  ThemeViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/05/06.
//

import UIKit

class ThemeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var applyID = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "着せ替え"
                        
        tableView.register(UINib(nibName: "ThemeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .labelColor
        view.backgroundColor = .secondaryBackgroundColor
        tableView.backgroundColor = .secondaryBackgroundColor
        tableView.reloadData()
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


        if applyID == theme.id{
            cell.applyButton.setTitle("適用済", for: .disabled)
            cell.applyButton.backgroundColor = .secondaryBackgroundColor
        }else {
//            cell.applyButton.setTitle("適用", for: .normal)
            cell.applyButton.backgroundColor = .secondaryBackgroundColor // teal
            cell.applyButton.setTitle("利用不可", for: .normal)
            cell.applyButton.setImage(UIImage(), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "Detail") as! ThemeDetailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
