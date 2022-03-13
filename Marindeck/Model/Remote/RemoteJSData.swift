//
//  RemoteJSData.swift
//  Marindeck
//
//  Created by a on 2022/02/04.
//
import GRDB

struct RemoteJSData: Codable, FetchableRecord, PersistableRecord {
    let _id: Int64?
    let id: String
    let title: String
    var version: Int
    var jsUrl: String
    var js: String?
}
