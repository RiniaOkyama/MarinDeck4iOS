//
//  Created by Menno Lovink on 03/05/16.
//  Copyright © 2016 M2mobi. All rights reserved.
//

import UIKit

class InlineAttributedStringViewLayoutBlockBuilder: LayoutBlockBuilder<UIView> {

    private(set) var urlOpener: URLOpener?

    private let converter: MarkDownConverter<NSMutableAttributedString>

    required init(converter: MarkDownConverter<NSMutableAttributedString>) {
        self.converter = converter
        super.init()
    }

    func attributedStringForMarkDownItem(_ markdownItem: MarkDownItem, styling: ItemStyling) -> NSMutableAttributedString {
        let string = NSMutableAttributedString()

        if let markDownItems = markdownItem.markDownItems {
            for subString in converter.convertToElements(markDownItems, applicableStyling: styling) {
                string.append(subString)
            }
        }

        return string
    }
}

extension InlineAttributedStringViewLayoutBlockBuilder: CanSetURLOpener {

    func set(urlOpener: URLOpener?) {
        self.urlOpener = urlOpener
    }
}

