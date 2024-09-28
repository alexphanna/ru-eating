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
            if settings.fdaDailyValues {
                return getFDADailyValues()
            }
            else {
                return rawValues[1]
            }
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
    
    func getFDADailyValues() -> OrderedDictionary<String, Float?> {
        var fdaDailyValues: OrderedDictionary<String, Float?> = OrderedDictionary<String, Float?>()
        
        for key in Array(rawValues[0].keys) {
            if key == "Sugars" || rawValues[0][key]! == nil {
                fdaDailyValues[key] = rawValues[1][key]!!
                continue
            }
            fdaDailyValues[key] = rawValues[0][key]!! / Float(dailyValues[key]!) * 100
        }
        
        return fdaDailyValues
    }
    
    func updateValues() async {
        do {
            rawValues = try await category.fetchValues(settings: settings)
        } catch {
            // do nothing
        }
    }
}
