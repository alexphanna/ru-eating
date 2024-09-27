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
    
    func fetchValues() async throws -> [OrderedDictionary<String, Float?>] {
        var values : [OrderedDictionary<String, Float?>] = [OrderedDictionary<String, Float?>]()
        
        // 0 - Amounts
        // 1 - Daily Values
        for i in 0...1 {
            let isAmounts: Bool = i == 0
            values.append(["Calories" : 0, "Fat" : 0, "Carbohydrates" : 0, "Saturated Fat" : 0, "Dietary Fiber" : 0, "Trans Fat" : (isAmounts ? 0 : nil), "Sugars" : 0, "Cholesterol" : (isAmounts ? 0 : nil), "Protein" : 0, "Sodium" : 0, "Iron" : (isAmounts ? nil : 0), "Calcium" : (isAmounts ? nil : 0)])
            for item in items {
                let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + item.id + "*1")!)
                if !hasNutritionalReport(doc: doc) {
                    continue
                }
                let elements = try! doc.select(isAmounts ? "div#nutritional-info table td, div#nutritional-info p:contains(Calories)" : "div#nutritional-info ul li").array()
                
                for element in elements {
                    let text = try! element.text()
                    let textArray = text.split(separator: isAmounts ? "\u{00A0}" : " \u{00A0}\u{00A0}")
                    
                    if textArray.count != 2 {
                        continue
                    }
                    let nutrient = isAmounts ? amountNutrients[String(textArray[0])]! : dailyValueNutrients[String(textArray[0])]!
                    
                    if values[i][nutrient]! == nil {
                        continue
                    }
                    values[i][nutrient]!! += Float(textArray[1].replacingOccurrences(of: isAmounts ? nutrientUnits[amountNutrients[String(textArray[0])]!]! : "%", with: ""))! * Float(item.portion) * Float(item.servingsNumber)
                }
            }
        }
        return values
    }
}
