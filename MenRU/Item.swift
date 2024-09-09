//
//  Item.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import Foundation

@Observable class Item : Hashable, Identifiable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
        hasher.combine(portion)
    }
    
    var name : String
    var id : String
    var ingredients: String
    var servingSize: Int
    var servingSizeUnit: String
    var portion: Int // number of servings
    var isFavorite: Bool
    
    func incrementPortion() {
        portion += 1
    }
    
    func decrementPoriton() {
        portion -= 1
        if portion < 0 { portion = 0 }
    }
    
    init(name: String, id: String, servingSize: Int, servingSizeUnit: String, portion: Int = 1, isFavorite: Bool = false) {
        self.name = name
        self.id = id
        self.servingSize = servingSize
        self.servingSizeUnit = servingSizeUnit
        self.portion = portion
        self.isFavorite = isFavorite
        self.ingredients = ""
    }
}
