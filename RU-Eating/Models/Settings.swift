//
//  Settings.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI
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
    var systemColorScheme: Bool?
    var colorScheme: Bool?
    var lastDiningHall: String
    var useHearts: Bool
    var itemDescriptions: Bool
    
    init(filterIngredients: Bool = false, restrictions: [String] = [], hideRestricted: Bool = false, carbonFootprints: Bool = true, hideZeros: Bool = false, hideNils: Bool = false, extraPercents: Bool = true, fdaDailyValues: Bool = false, systemColorScheme: Bool? = nil, colorScheme: Bool? = nil, lastDiningHall: String = "Busch", useHearts: Bool = false, itemDescriptions: Bool = true) {
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
        self.systemColorScheme = systemColorScheme
        self.colorScheme = colorScheme
        self.lastDiningHall = lastDiningHall
        self.useHearts = useHearts
        self.itemDescriptions = itemDescriptions
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
