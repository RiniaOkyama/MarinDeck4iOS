//
//  UIImage+URL.swift
//  Marindecker
//
//  Created by Rinia on 2021/03/15.
//

import Foundation
import UIKit

extension UIImage {
    enum FetchError: Error {
        case badUrl, badImage, apiError(Error)
    }
    
    public convenience init?(url: String) async throws {
        guard let url = URL(string: url) else {
            self.init()
            return
        }
        do {  
            var request = URLRequest(url: url)
            // https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy
            request.cachePolicy = .returnCacheDataElseLoad

            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badUrl }
            self.init(data: data)
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
