//
//  Category.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import Foundation
import OrderedCollections

@Observable class Category : Hashable, Identifiable {
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
    
    init(name: String, items: [Item] = [Item]()) {
        self.name = name
        self.items = items
        self.id = UUID()
    }
    
    func fetchValues(settings: Settings) async throws -> [OrderedDictionary<String, Float?>] {
        var values : [OrderedDictionary<String, Float?>] = [OrderedDictionary<String, Float?>]()
        values.append(["Calories" : 0, "Fat" : 0, "Carbohydrates" : 0, "Saturated Fat" : 0, "Dietary Fiber" : 0, "Trans Fat" : 0, "Sugars" : 0, "Cholesterol" : 0, "Protein" : 0, "Sodium" : 0, "Iron" : nil, "Calcium" : nil])
        values.append(["Calories" : 0, "Fat" : 0, "Carbohydrates" : 0, "Saturated Fat" : 0, "Dietary Fiber" : 0, "Trans Fat" : nil, "Sugars" : 0, "Cholesterol" : nil, "Protein" : 0, "Sodium" : 0, "Iron" : 0, "Calcium" : 0])
        
        // 0 - Amounts
        // 1 - Daily Values
        for i in 0...1 {
            let isAmounts: Bool = i == 0
            for item in items {
                let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + item.id + "*1")!)
                if !hasNutritionalReport(doc: doc) {
                    continue
                }
                let elements = try! doc.select(isAmounts ? "div#nutritional-info table td, div#nutritional-info p:contains(Calories)" : "div#nutritional-info ul li").array()
                
                for element in elements {
                    let text = try! element.text()
                    let textArray = text.split(separator: isAmounts ? "\u{00A0}" : " \u{00A0}\u{00A0}")
                    
                    if textArray.count == 0 || (isAmounts && amountNutrients[String(textArray[0])] == nil) || (!isAmounts && dailyValueNutrients[String(textArray[0])] == nil) {
                        continue
                    }
                    
                    if textArray.count != 2 {
                        continue
                    }
                    let nutrient = isAmounts ? amountNutrients[String(textArray[0])]! : dailyValueNutrients[String(textArray[0])]!
                    let value = Float(textArray[1].replacingOccurrences(of: isAmounts ? nutrientUnits[nutrient]! : "%", with: ""))! * Float(item.portion) * Float(item.servingsNumber)
                    if settings.extraPercents {
                        if isAmounts {
                            if nutrient == "Cholesterol" {
                                values[1][nutrient]! = value / 3
                            }
                        }
                        else if !isAmounts {
                            if nutrient == "Iron" {
                                values[0][nutrient] = value / 100 * 18
                            }
                            else if nutrient == "Calcium" {
                                values[0][nutrient] = value / 100 * 1300
                            }
                        }
                    }
                    values[i][nutrient]!! += value
                }
            }
        }
        return values
    }
}
