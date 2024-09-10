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
    var hideUnfavorited: Bool
    
    init(filterIngredients: Bool = false, restrictions: [String] = [], hideRestricted: Bool = false, hideUnfavorited: Bool = false) {
        self.filterIngredients = filterIngredients
        self.hideRestricted = hideRestricted
        self.restrictions = restrictions
        self.favoriteItemsIDs = [String]()
        self.hideUnfavorited = hideUnfavorited
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
