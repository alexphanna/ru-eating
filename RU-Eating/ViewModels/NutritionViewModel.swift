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
    
    private var settings: Settings
    private(set) var showServingSize: Bool
    var unit: String
    var servings: Int
    
    private var rawValues: [OrderedDictionary<String, Float?>]
    var values: OrderedDictionary<String, Float?> {
        switch(unit) {
        case "Amounts":
            return rawValues[0]
        default:
            return rawValues[1]
        }
    }
    
    init(category: Category, showServingSize: Bool = false, settings: Settings) {
        self.category = category
        
        self.showServingSize = showServingSize
        self.rawValues = [OrderedDictionary<String, Float?>(), OrderedDictionary<String, Float?>()]
        self.unit = "Amounts"
        self.servings = 0
        self.settings = settings
    }
    
    func updateValues() async {
        do {
            rawValues = try await category.fetchValues(settings: settings)
        } catch {
            // do nothing
        }
    }
}
