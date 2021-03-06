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
    case loadImage = "loadImage"
    case fetchImage = "fetchImage"
    case selectedImageBase64 = "selectedImageBase64"
    case isTweetButtonHidden = "isTweetButtonHidden"
    case openYoutube = "openYoutube"
    case sidebar = "sidebar"
    case config = "config"
}
