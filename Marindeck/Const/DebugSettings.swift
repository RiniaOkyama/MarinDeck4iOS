//
// Created by Rinia on 2021/11/02.
//

import Foundation

struct DebugSettings {
    #if DEBUG
    static let isWebViewLoad = false
    #else
    static let isWebViewLoad = true
    #endif
}