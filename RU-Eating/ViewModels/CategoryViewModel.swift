//
//  CategoryViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import OrderedCollections

@Observable class CategoryViewModel {
    var category: Category
    var nutrient: String
    var isExpandable: Bool
    var isExpanded: Bool
    var sortBy: String
    var sortOrder: String
    //var nutrientIndex: Int
    
    init(category: Category, nutrient: String, sortBy: String, sortOrder: String, isExpandable: Bool = true) {
        self.category = category
        self.nutrient = nutrient
        //self.nutrientIndex = nutrientIndex
        self.isExpandable = isExpandable
        self.isExpanded = true
        self.sortBy = sortBy
        self.sortOrder = sortOrder
    }
    
    var sortedItems: [Item] {
        var items = [Item]()
        switch sortBy {
        case "Name":
            items = category.items.sorted(by: { $0.name < $1.name })
        case "Nutrient":
            items = category.items.sorted(by: { $0.amounts[nutrient]! ?? 0 < $1.amounts[nutrient]! ?? 0 })
        default:
            items = [Item]()
        }
        
        if sortOrder == "Descending" {
            items = items.reversed()
        }
        
        return items
    }
    
    func nextNutrient() {
        nutrient = nutrients.randomElement()! 
    }
}
