//
//  ItemViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import SwiftUI

@Observable class ItemViewModel {
    var item: Item
    var settings: Settings
    var searchText: String
    
    var carbonFootprintColor: Color {
        return item.carbonFootprint == 1 ? .green : item.carbonFootprint == 2 ? .orange : .red
    }
    
    private var containsRestrictions: Bool {
        for restriction in settings.restrictions {
            if item.ingredients.lowercased().contains(restriction.lowercased()) || item.name.lowercased().contains(restriction.lowercased()) {
                return true
            }
        }
        return false
    }
    
    init(item: Item, settings: Settings) {
        self.item = item
        self.settings = settings
        self.searchText = ""
    }
    
    func updateItem() async {
        if item.ingredients.isEmpty {
            do {
                item.ingredients = try await item.fetchIngredients()
                item.restricted = containsRestrictions
            } catch {
                // do nothing
            }
        }
    }
}
