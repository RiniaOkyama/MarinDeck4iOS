//
//  RemoteJS.swift
//  Marindeck
//
//  Created by a on 2022/02/02.
//

import Alamofire
import Foundation

class RemoteJS {
    static let shared = RemoteJS()
    
    private lazy var dbQueue = Database.shared.dbQueue

    public private(set) var remoteJSs: [RemoteJSData]?
    private var savedRemoteJSs: [RemoteJSData]?
    
    func update(completion: @escaping() -> ()) {
        fetchDb()
        fetch { [weak self] remoteJSs in
            guard let self = self else { return }
            self.remoteJSs = remoteJSs
        
            for remoteJS in remoteJSs ?? [] {
                if !self.isLatest(latest: remoteJS) {
                    let result = self.fetchJS(remoteJS: remoteJS)
                    self.saveDb(remoteJS: result)
                }
            }
            self.fetchDb()
            completion()
        }
    }
    
    func getJs(id: RemoteJSDataId) -> String? {
        savedRemoteJSs?.filter { $0.id == id.rawValue }[safe: 0]?.js
    }
    
    
    func isLatest(id: RemoteJSDataId) -> Bool {
        guard let latest = remoteJSs?.filter({ $0.id == id.rawValue })[safe: 0] else { return false }
        return isLatest(latest: latest)
    }
    
    func isLatest(latest: RemoteJSData) -> Bool {
        guard let currentVersion = savedRemoteJSs?.filter({ $0.id == latest.id })[safe: 0]?.version else { return false }
        
        return currentVersion >= latest.version
    }
    
    private func fetch(completion: @escaping([RemoteJSData]?) -> ()) {
        AF.request(DebugSettings.remoteJsUrl).response { response in
            guard let data = response.data else { return }
            let remoteJs = try? JSONDecoder().decode([RemoteJSData].self, from: data)
            completion(remoteJs)
        }
    }
    
    
    private func fetchDb() {
        savedRemoteJSs = try! dbQueue.read { db in
            try RemoteJSData.fetchAll(db)
        }
    }
    
    private func saveDb(remoteJS: RemoteJSData) {
        if let rjs = savedRemoteJSs?.filter({ $0.id == remoteJS.id })[safe: 0] {
            var saverjs = rjs
            saverjs.version = remoteJS.version
            saverjs.jsUrl = remoteJS.jsUrl
            saverjs.js = remoteJS.js
            try! dbQueue.write { db in
                try saverjs.update(db)
            }
        } else {
            try! dbQueue.write { db in
                try remoteJS.insert(db)
            }
        }
    }
    
    private func fetchJS(remoteJS: RemoteJSData) -> RemoteJSData {
        print(#function)
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
        var result = remoteJS
        AF.request(remoteJS.jsUrl).response(queue: queue) { response in
            print(response)
            guard let data = response.data else {
                semaphore.signal()
                return
            }
            var tmpRemoteJS = remoteJS
            tmpRemoteJS.js = String(data: data, encoding: .utf8)
            result = tmpRemoteJS
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }

    
}
