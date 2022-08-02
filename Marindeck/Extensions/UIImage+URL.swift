//
//  UIImage+URL.swift
//  Marindecker
//
//  Created by Rinia on 2021/03/15.
//

import Foundation
import UIKit

extension UIImage {
    public convenience init?(url: String) {
        guard let url = URL(string: url) else {
            self.init()
            return
        }
        do {
            print(url)
            let data = try Data(contentsOf: url)
            self.init(data: data)
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
