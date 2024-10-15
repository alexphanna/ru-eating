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
    var nutrientIndex: Int
    
    var isEditing : Bool
    
    init(category: Category, nutrient: String, sortBy: String, sortOrder: String, isExpandable: Bool = true, isEditing: Bool) {
        self.category = category
        self.nutrient = nutrient
        self.nutrientIndex = 0
        self.isExpandable = isExpandable
        self.isExpanded = true
        self.sortBy = sortBy
        self.sortOrder = sortOrder
        self.isEditing = isEditing
    }
    
    var sortedItems: [Item] {
        var items = category.items
        
        switch sortBy {
        case "Name":
            items.sort { $0.name < $1.name }
            break
        case "Nutrient":
            items = category.items.filter( { $0.fetched } ).sorted { $0.amounts[nutrient]! ?? -1 < $1.amounts[nutrient]! ?? -1 }
            break
        case "Carbon Footprint":
            items = category.items.filter( { $0.carbonFootprint > 0 } ).sorted { $0.carbonFootprint < $1.carbonFootprint }
            break
        case "Ingredients":
            items = category.items.filter( { $0.ingredientsCount != nil } ).sorted { $0.ingredientsCount! < $1.ingredientsCount! }
            break
        default:
            break
        }
        
        if self.sortOrder == "Descending" {
            items = items.reversed()
        }
        
        switch sortBy {
        case "Carbon Footprint":
            items.append(contentsOf: category.items.filter( { $0.carbonFootprint == 0 } ))
            break
        case "Ingredients":
            items.append(contentsOf: category.items.filter( { $0.ingredientsCount == nil } ))
            break
        default:
            break
        }
        
        return items
    }
    
    func nextNutrient() {
        nutrientIndex += 1
        if nutrientIndex == nutrients.count {
            nutrientIndex = 0
        }
        nutrient = nutrients[nutrientIndex]
    }
}
