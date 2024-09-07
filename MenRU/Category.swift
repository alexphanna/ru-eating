//
//  Category.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import Foundation

struct Category : Hashable, Identifiable {
    let name : String
    var items : [Item]
    let id = UUID()
}
