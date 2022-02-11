//
//  TDTools.swift
//  Marindeck
//
//  Created by a on 2022/02/11.
//

import Foundation

class TDTools {
    
    static func url2SmallImg(_ str: String) -> String {
        var r = str.replacingOccurrences(of: "url(\"", with: "")
        r = r.replacingOccurrences(of: "\")", with: "")
        return r
    }

    static func url2NomalImg(_ str: String) -> String {
        var r = url2SmallImg(str)
        if let index = r.range(of: "&name")?.lowerBound {
            r = String(r[...index]) // + "name=orig"
            return r.replacingOccurrences(of: "format=jpg", with: "format=png")
        }
        return ""
    }

}
