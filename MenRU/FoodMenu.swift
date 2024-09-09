//
//  Menu.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import Foundation

@Observable class FoodMenu: Hashable {
    static func == (lhs: FoodMenu, rhs: FoodMenu) -> Bool {
        return lhs.categories == rhs.categories
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(categories)
    }
    
    var categories: [Category]
    
    init() {
        self.categories = [Category]()
    }
}
