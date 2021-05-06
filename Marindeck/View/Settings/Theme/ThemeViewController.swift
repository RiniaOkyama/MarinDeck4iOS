//
//  ThemeViewController.swift
//  Marindeck
//
//  Created by craptone on 2021/05/06.
//

import UIKit

struct Theme: Codable{
    var title: String // テーマ名
    var id: String // かさらないように。一度変更したら変更しないでください。
    var description: String // テーマの説明
    var icon: String // テーマのアイコンURL。アイコン作るセンスがなければ設定しないほうがいい。
//    var screenshots: [UIImage] // スクリーンショット。
    var js: String // テーマのJS。テーマに関係ないjsは含まないこと。
    var css: String // テーマのCSS。
}

class ThemeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var applyID = "0"
    
    let themes = [
        Theme(title: "デフォルト", id: "0", description: "デフォルトでず。", icon: "", js: "", css: ""),
        Theme(title: "Midnight", id: "1", description: "Midra", icon: "", js: "", css: ""),
        Theme(title: "Wumpus", id: "2", description: "hakunagi", icon: "", js: "", css: ""),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "着せ替え"
        
        view.backgroundColor = .secondarySystemBackground
        
        tableView.register(UINib(nibName: "ThemeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThemeTableViewCell
        
        let theme = themes[indexPath.row]
        cell.titleLabel.text = theme.title
        cell.descriptionLabel.text = theme.description

        if applyID == theme.id{
            cell.applyButton.setTitle("適用済", for: .disabled)
            cell.applyButton.backgroundColor = .systemGray6
        }else {
//            cell.applyButton.setTitle("適用", for: .normal)
            cell.applyButton.backgroundColor = .systemGray6 // teal
            cell.applyButton.setTitle("利用不可", for: .normal)
            cell.applyButton.setImage(UIImage(), for: .normal)
        }
        
        return cell
    }
    
}
