//
//  Error+.swift
//  Marindecker
//
//  Created by craptone on 2021/01/17.
//

import Foundation
extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var info:  [String:Any] { return (self as NSError).userInfo }
}
