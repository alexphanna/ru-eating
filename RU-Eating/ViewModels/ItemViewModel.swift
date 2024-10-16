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
    var nutrient: String
    var sortBy: String
    
    var isEditing : Bool
    
    var carbonFootprintColor: Color {
        return item.carbonFootprint == 1 ? .green : item.carbonFootprint == 2 ? .orange : .red
    }
    
    var containsRestrictions: Bool {
        for restriction in restrictions {
            if item.ingredients.lowercased().contains(restriction.lowercased()) || item.name.lowercased().contains(restriction.lowercased()) {
                return true
            }
        }
        return false
    }
    
    @ObservationIgnored @AppStorage("favoriteItemsIDs") var favoriteItemsIDs: [String] = []
    @ObservationIgnored @AppStorage("restrictions") var restrictions: [String] = []
    
    init(item: Item, nutrient: String, sortBy: String, isEditing: Bool) {
        self.item = item
        self.nutrient = nutrient
        self.sortBy = sortBy
        self.isEditing = isEditing
    }
    
    func favorite() {
        item.isFavorite = !item.isFavorite
        if item.isFavorite {
            favoriteItemsIDs.append(item.id)
        }
        else if !item.isFavorite {
            favoriteItemsIDs.removeAll(where: { $0 == item.id })
        }
    }
}
