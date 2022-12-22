//
//  JSCallbackFlag.swift
//  Marindeck
//
//  Created by Rinia on 2021/10/06.
//

enum JSCallbackFlag: String, CaseIterable, Codable {
    case jsCallbackHandler = "jsCallbackHandler" // デバッグ用
    case imagePreviewer = "imagePreviewer"
    case imageViewPos = "imageViewPos" // 画像の座標
    case viewDidLoad = "viewDidLoad"
    case openSettings = "openSettings"
    case presentAlert = "presentAlert"
    case fetchImage = "fetchImage"
    case isTweetButtonHidden = "isTweetButtonHidden"
    case openYoutube = "openYoutube"
    case sidebar = "sidebar"
    case config = "config"
    case openUrl = "openUrl"
}

protocol JSCallback {
    func viewDidLoad()
    func jsCallbackHandler(log: Any?)
    func imageViewPos(positions: [[Float]])
    func imagePreviewer(selectedIndex: Int, urls: [String])
    func openSettings()
    func presentAlert(message: String)
    func fetchImage(url: String)
    func isTweetButtonState(isHidden: Bool)
    func openYoutube(url: String)
    func sidebarState(isOpen: Bool)
    func setConfig(key: String, value: String)
    func getConfig(key: String) -> Any?
    func openUrl(url: String)
}
