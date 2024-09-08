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
    
    init(filterIngredients: Bool = false, restrictions: [String] = [], hideRestricted: Bool = false) {
        self.filterIngredients = filterIngredients
        self.hideRestricted = hideRestricted
        self.restrictions = restrictions
    }
}
