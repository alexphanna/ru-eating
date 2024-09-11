//
//  Category.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import Foundation

@Observable class Category : Hashable, Identifiable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(items)
        hasher.combine(id)
    }
    
    let name : String
    var items : [Item]
    let id: UUID
    var portions: Int {
        get {
            var totalPortions = 0
            for item in items {
                totalPortions += item.portion
            }
            return totalPortions
        }
    }
    
    init(name: String, items: [Item] = [Item]()) {
        self.name = name
        self.items = items
        self.id = UUID()
    }
}
