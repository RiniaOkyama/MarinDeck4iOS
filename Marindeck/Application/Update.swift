//
//  Update.swift
//  Marindeck
//
//  Created by Rinia on 2021/11/28.
//

import Foundation

class Update {
    static let shared = Update()

    public let appId = "1558663979"

    func checkForUpdate(completion: @escaping (_ update: Bool) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/jp/lookup?id=\(appId)") else {
            completion(false)
            return
        }

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) in
            guard let data = data else {
                completion(false)
                return
            }

            do {
                let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let storeVersion = ((jsonData?["results"] as? [Any])?
                                            .first as? [String: Any])?["version"] as? String,
                      let appVersion = Bundle.main
                        .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                    completion(false)
                    return
                }
                switch storeVersion.compare(appVersion, options: .numeric) {
                case .orderedDescending:
                    completion(true)
                    return
                case .orderedSame, .orderedAscending:
                    completion(false)
                    return
                }
            } catch {
            }
        })
        task.resume()
    }

}
