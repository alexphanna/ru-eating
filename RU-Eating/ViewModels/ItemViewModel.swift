//
//  ItemViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import SwiftUI
import Observation

class ItemViewModel: ObservableObject {
    @Published var item: Item
    var nutrient: String
    var sortBy: String
    
    @Published var isEditing : Bool
    
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
    
    @AppStorage("favoriteItems") var favoriteItems: [String] = []
    @AppStorage("restrictions") var restrictions: [String] = []
    
    init(item: Item, nutrient: String, sortBy: String, isEditing: Bool) {
        self.item = item
        self.nutrient = nutrient
        self.sortBy = sortBy
        self.isEditing = isEditing
    }
    
    func favorite() {
        item.isFavorite = !item.isFavorite
        if item.isFavorite {
            favoriteItems.append(item.name)
        }
        else if !item.isFavorite {
            favoriteItems.removeAll(where: { $0 == item.name })
        }
    }
}
