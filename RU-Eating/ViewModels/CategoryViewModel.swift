//
//  CategoryViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import OrderedCollections
import SwiftUI

@Observable class CategoryViewModel {
    var category: Category
    var isExpandable: Bool
    var isExpanded: Bool
    var sortBy: String
    var sortOrder: String
    var nutrientIndex: Int
    
    var isEditing : Bool
    
    init(category: Category, sortBy: String, sortOrder: String, isExpandable: Bool = true, isEditing: Bool) {
        self.category = category
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
        case "Calories":
            items = category.items.filter( { $0.fetched } ).sorted { $0.amounts["Calories"]! ?? -1 < $1.amounts["Calories"]! ?? -1 }
            break
        case "Fat":
            items = category.items.filter( { $0.fetched } ).sorted { $0.amounts["Fat"]! ?? -1 < $1.amounts["Fat"]! ?? -1 }
            break
        case "Carbohydrates":
            items = category.items.filter( { $0.fetched } ).sorted { $0.amounts["Carbohydrates"]! ?? -1 < $1.amounts["Carbohydrates"]! ?? -1 }
            break
        case "Protein":
            items = category.items.filter( { $0.fetched } ).sorted { $0.amounts["Protein"]! ?? -1 < $1.amounts["Protein"]! ?? -1 }
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
}
