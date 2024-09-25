//
//  NutritionViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import OrderedCollections

@Observable class NutritionViewModel {
    private(set) var category: Category
    
    private(set) var showServingSize: Bool
    var unit: String
    var servings: Int
    private var amounts: OrderedDictionary<String, Float>
    private var dailyValues: OrderedDictionary<String, Float>
    
    var values: OrderedDictionary<String, Float> {
        switch(unit) {
        case "Amount":
            return amounts
        default:
            return dailyValues
        }
    }
    
    init(category: Category, showServingSize: Bool = false) {
        self.category = category
        
        self.showServingSize = showServingSize
        self.amounts = OrderedDictionary<String, Float>()
        self.dailyValues = OrderedDictionary<String, Float>()
        self.unit = "Amount"
        self.servings = 0
    }
    
    func updateValues() async {
        do {
            amounts = try await category.fetchAmounts()
            dailyValues = try await category.fetchDailyValues()
        } catch {
            // do nothing
        }
    }
}
