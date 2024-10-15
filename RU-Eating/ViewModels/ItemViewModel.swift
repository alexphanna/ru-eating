//
//  ItemViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import SwiftUI
import Observation

@Observable class ItemViewModel {
    var item: Item
    var settings: Settings
    var nutrient: String
    var sortBy: String
    
    var isEditing : Bool
    
    var carbonFootprintColor: Color {
        return item.carbonFootprint == 1 ? .green : item.carbonFootprint == 2 ? .orange : .red
    }
    
    var containsRestrictions: Bool {
        for restriction in settings.restrictions {
            if item.ingredients.lowercased().contains(restriction.lowercased()) || item.name.lowercased().contains(restriction.lowercased()) {
                return true
            }
        }
        return false
    }
    
    init(item: Item, nutrient: String, sortBy: String, settings: Settings, isEditing: Bool) {
        self.item = item
        self.nutrient = nutrient
        self.sortBy = sortBy
        self.settings = settings
        self.isEditing = isEditing
    }
}
