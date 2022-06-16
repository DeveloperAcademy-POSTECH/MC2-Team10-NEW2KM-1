//
//  ConsumedItem.swift
//  Moasa
//
//  Created by Junyeong Park on 2022/06/16.
//

import Foundation

struct ConsumedItem: Codable, Identifiable {
    let id = UUID()
    var consumedCategory: String
    var consumedName: String
    var consumedPrice: Int
    var consumedDate: Date
    var consumedMemo: String? = nil
}
