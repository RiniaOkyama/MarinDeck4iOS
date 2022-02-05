//
//  RemoteJSData.swift
//  Marindeck
//
//  Created by a on 2022/02/04.
//
import GRDB

struct RemoteJSData: Codable, FetchableRecord, PersistableRecord {
    let id: String
    let title: String
    let version: Int
    let jsUrl: String
    var js: String?
}
