//
//  Array+safe.swift
//  Marindeck
//
//  Created by a on 2022/01/04.
//

extension Array {
    subscript (safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}
