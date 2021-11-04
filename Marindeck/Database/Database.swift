//
//  Database.swift
//  Marindeck
//
//  Created by craptone on 2021/10/30.
//

import Foundation
import GRDB


// FIXME: Modelに移動
struct CustomJS: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var title: String
    var js: String
    var createAt: Date
    var updateAt: Date
    var loadIndex: Int32
    var isLoad: Bool
}

// FIXME: Modelに移動
struct CustomCSS: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var title: String
    var css: String
    var createAt: Date
    var updateAt: Date
    var loadIndex: Int32
    var isLoad: Bool
}

class Database {
    static let shared = Database()

    public lazy var dbQueue: DatabaseQueue = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return try! DatabaseQueue(path: dir.absoluteString + "database.sqlite")
    }()
    
    
    func setup() {
        
        try? dbQueue.write { db in
            // CustomJS
            try db.create(table: "customjs") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("js", .text).notNull()
                t.column("createAt", .date).notNull()
                t.column("updateAt", .date).notNull()
                t.column("loadIndex", .integer).notNull()
                t.column("isLoad", .boolean).notNull()
            }
            
            // CustomCSS
            try db.create(table: "customcss") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("css", .text).notNull()
                t.column("createAt", .date).notNull()
                t.column("updateAt", .date).notNull()
                t.column("loadIndex", .integer).notNull()
                t.column("isLoad", .boolean).notNull()
            }
        }
    }

}
//
//class CustomJSs {
//
//}