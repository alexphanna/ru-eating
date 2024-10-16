//
//  NutritionViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import OrderedCollections
import SwiftUI

@Observable class NutritionViewModel {
    private(set) var category: Category
    
    private(set) var showServingSize: Bool
    var unit: String
    var servings: Int
    
    @ObservationIgnored @AppStorage("fdaDailyValues") var fdaDailyValues = false
    
    var values: OrderedDictionary<String, Float?> {
        switch(unit) {
        case "Amounts":
            return category.amounts
        default:
            if fdaDailyValues {
                return getFDADailyValues()
            }
            else {
                return category.dailyValues
            }
        }
    }
    
    init(category: Category, showServingSize: Bool = false) {
        self.category = category
        
        self.showServingSize = showServingSize
        self.unit = "Amounts"
        self.servings = 0
    }
    
    func getFDADailyValues() -> OrderedDictionary<String, Float?> {
        var fdaDailyValues: OrderedDictionary<String, Float?> = OrderedDictionary<String, Float?>()
        
        for key in Array(category.amounts.keys) {
            if key == "Sugars" || category.amounts[key]! == nil {
                fdaDailyValues[key] = category.dailyValues[key]!!
                continue
            }
            fdaDailyValues[key] = category.amounts[key]!! / Float(dailyValues[key]!) * 100
        }
        
        return fdaDailyValues
    }
}
