//
//  Category.swift
//  RU Eating
//
//  Created by alex on 10/14/24.
//

import Foundation
import OrderedCollections

@Observable class Category: Identifiable, Hashable {
    static func == (lhs: Category, rhs: Category) -> Bool {
            return lhs.name == rhs.name && lhs.items == rhs.items
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(items)
            hasher.combine(id)
        }
        
        let name : String
        var items : [Item]
        let id: UUID
        var portions: Float {
            get {
                var totalPortions: Float = 0.0
                for item in items {
                    totalPortions += item.portion
                }
                return totalPortions
            }
        }
        
        var dailyValues: OrderedDictionary<String, Float?> {
            var dailyValues: OrderedDictionary<String, Float?> = ["Calorie" : nil, "Fat" : nil, "Carbohydrates" : nil, "Saturated Fat" : nil, "Dietary Fiber" : nil, "Trans Fat" : nil, "Sugars" : nil, "Cholesterol" : nil, "Protein" : nil, "Sodium" : nil, "Iron" : nil, "Calcium" : nil]
            for item in items {
                for key in Array(dailyValues.keys) {
                    if item.dailyValues[key]! != nil {
                        if dailyValues[key]! == nil {
                            dailyValues[key]! = 0
                        }
                        dailyValues[key]!! += item.dailyValues[key]!!
                    }
                }
            }
            return dailyValues
        }
        
        var amounts: OrderedDictionary<String, Float?> {
            var amounts: OrderedDictionary<String, Float?> = ["Calories" : nil, "Fat" : nil, "Carbohydrates" : nil, "Saturated Fat" : nil, "Dietary Fiber" : nil, "Trans Fat" : nil, "Sugars" : nil, "Cholesterol" : nil, "Protein" : nil, "Sodium" : nil, "Iron" : nil, "Calcium" : nil]
            for item in items {
                for key in Array(amounts.keys) {
                    if item.amounts[key]! != nil {
                        if amounts[key]! == nil {
                            amounts[key]! = 0
                        }
                        amounts[key]!! += item.amounts[key]!!
                    }
                }
            }
            return amounts
        }
        
        init(name: String, items: [Item] = [Item]()) {
            self.name = name
            self.items = items
            self.id = UUID()
        }
}
