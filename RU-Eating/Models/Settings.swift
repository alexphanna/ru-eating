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
    
    var hideZeros: Bool
    var hideNils: Bool
    var carbonFootprints: Bool
    var extraPercents: Bool
    var fdaDailyValues: Bool
    
    init(filterIngredients: Bool = false, restrictions: [String] = [], hideRestricted: Bool = false, carbonFootprints: Bool = true, hideZeros: Bool = false, hideNils: Bool = false, extraPercents: Bool = true, fdaDailyValues: Bool = false) {
        self.filterIngredients = filterIngredients
        self.hideRestricted = hideRestricted
        self.restrictions = restrictions
        self.carbonFootprints = carbonFootprints
        self.favoriteItemsIDs = [String]()
        self.numberOfUses = 1
        self.hideZeros = hideZeros
        self.hideNils = hideNils
        self.extraPercents = extraPercents
        self.fdaDailyValues = fdaDailyValues
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
