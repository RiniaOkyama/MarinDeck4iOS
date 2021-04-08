//
//  NSAttributedString+FullRange.swift
//  MarkyMark
//
//  Created by Menno Lovink on 03/05/16.
//  Copyright © 2016 M2mobi. All rights reserved.
//

import UIKit

internal extension NSAttributedString {

    func fullRange() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
}
