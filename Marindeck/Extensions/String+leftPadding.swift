//
//  String+leftPadding.swift
//  Marindecker
//
//  Created by craptone on 2021/01/13.
//

import Foundation

extension String {

      func leftPadding(toLength: Int, withPad: String) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeating:withPad, count: toLength - stringLength) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
