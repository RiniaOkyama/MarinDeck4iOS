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
        let queue = DispatchQueue.global(qos: .background)
        let semaphore = DispatchSemaphore(value: 10)
        
        fetch { [weak self] remoteJSs in
            guard let self = self else { return }
            self.remoteJSs = remoteJSs
            
            for remoteJS in remoteJSs ?? [] {
                if !self.isLatest(latest: remoteJS) {
                    queue.async {
                        self.fetchJS(remoteJS: remoteJS) { result in
                            semaphore.signal()
                        }
                        semaphore.wait()
                    }
                }
                
            }
            
            completion()
        }
    }
    
    func getJs(id: RemoteJSDataId) -> String? {
        remoteJSs?.filter { $0.id == id.rawValue }[safe: 0]?.js
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
    
    private func fetchJS(remoteJS: RemoteJSData, completion: @escaping(RemoteJSData) -> ()) {
        AF.request(remoteJS.jsUrl).response { response in
            guard let data = response.data else { return }
            var tmpRemoteJS = remoteJS
            tmpRemoteJS.js = String(data: data, encoding: .utf8)
            completion(tmpRemoteJS)
        }
        
    }

    
}

func aa() {
    let remoteJs = RemoteJS.shared
    remoteJs.getJs(id: .navigationTab)
}
