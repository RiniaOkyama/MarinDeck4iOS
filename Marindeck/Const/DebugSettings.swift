//
// Created by Rinia on 2021/11/02.
//

import Foundation

struct DebugSettings {
    #if DEBUG
    static let isWebViewLoad = true
    static let remoteJsUrl = "https://raw.githubusercontent.com/RiniaOkyama/MarinDeck4iOS-RemoteJS/main/v1.json"
    #else
    static let isWebViewLoad = true
    static let remoteJsUrl = "https://raw.githubusercontent.com/RiniaOkyama/MarinDeck4iOS-RemoteJS/main/v1.json"
    #endif
}
