//
//  Settings.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftData

@Model
class Settings {
    var filterIngredients: Bool
    var restrictions: [String]
    var hideRestricted: Bool
    var favoriteItemsIDs: [String]
    var numberOfUses: Int
    var carbonFootprints: Bool
    
    init(filterIngredients: Bool = false, restrictions: [String] = [], hideRestricted: Bool = false, carbonFootprints: Bool = true) {
        self.filterIngredients = filterIngredients
        self.hideRestricted = hideRestricted
        self.restrictions = restrictions
        self.carbonFootprints = carbonFootprints
        self.favoriteItemsIDs = [String]()
        self.numberOfUses = 1
    }
    
    func favorite(item: Item) {
        item.isFavorite = !item.isFavorite
        if item.isFavorite {
            favoriteItemsIDs.append(item.id)
        }
        else if !item.isFavorite {
            favoriteItemsIDs.removeAll(where: { $0 == item.id })
        }
    }
}