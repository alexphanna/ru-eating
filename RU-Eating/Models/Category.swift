//
//  Category.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import Foundation
import OrderedCollections

class Category : Hashable, Identifiable {
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
    
    func fetchAmounts() async throws -> OrderedDictionary<String, Float> {
        let amountNutrients = [
            "Calories" : "Calories",
            "Total Fat" : "Fat",
            "Tot. Carb." : "Carbohydrates",
            "Sat. Fat" : "Saturated Fat",
            "Dietary Fiber" : "Dietary Fiber",
            "Trans Fat" : "Trans Fat",
            "Sugars" : "Sugars",
            "Cholesterol" : "Cholesterol",
            "Protein" : "Protein",
            "Sodium" : "Sodium"
        ]
        var amounts = OrderedDictionary<String, Float>();
        
        for item in items {
            let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + item.id + "*1")!)
            if !hasNutritionalReport(doc: doc) {
                continue
            }
            let elements = try! doc.select("div#nutritional-info table td, div#nutritional-info p:contains(Calories)").array()
            // , div#nutritional-info p:contains(Serving Size)
            
            for element in elements {
                let text = try! element.text()
                /*if text.contains("Serving Size") {
                    amounts["Serving Size"] = String(text.replacingOccurrences(of: "Serving Size ", with: "")).capitalized
                    continue
                }*/
                let textArray = text.split(separator: "\u{00A0}")
                
                if textArray.count != 2 {
                    continue
                }
                if amounts[amountNutrients[String(textArray[0])]!] == nil {
                    amounts[amountNutrients[String(textArray[0])]!] = Float(textArray[1].replacingOccurrences(of: nutrientUnits[amountNutrients[String(textArray[0])]!]!, with: ""))! * Float(item.portion) * Float(item.servingsNumber)
                }
                else {
                    amounts[amountNutrients[String(textArray[0])]!]! += Float(textArray[1].replacingOccurrences(of: nutrientUnits[amountNutrients[String(textArray[0])]!]!, with: ""))! * Float(item.portion) * Float(item.servingsNumber)
                }
            }
        }
        
        return amounts;
    }
    
    func fetchDailyValues() async throws -> OrderedDictionary<String, Float> {
        let dailyValueNutrients = [
            "Calories" : "Calories",
            "Protein" : "Protein",
            "Fat" : "Fat",
            "Carbohydrates" : "Carbohydrates",
            "Cholesterol" : "Cholesterol",
            "Total Sugars" : "Sugars",
            "Dietary Fiber" : "Dietary Fiber",
            "Sodium" : "Sodium",
            "Saturated Fat" : "Saturated Fat",
            "Calcium" : "Calcium",
            "Trans Fatty Acid" : "Trans Fat",
            "Mono Fat" : "Mono Fat",
            "Poly Fat" : "Poly Fat",
            "Iron" : "Iron"
        ];
        var dailyValues = OrderedDictionary<String, Float>();
        
        for item in items {
            let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + item.id + "*1")!)
            if !hasNutritionalReport(doc: doc) {
                continue
            }
            let elements = try! doc.select("div#nutritional-info ul li").array()
            
            for element in elements {
                let text = try! element.text()
                let textArray = text.split(separator: " \u{00A0}\u{00A0}")
                
                if textArray.count != 2 {
                    continue
                }
                if dailyValues[dailyValueNutrients[String(textArray[0])]!] == nil {
                    dailyValues[dailyValueNutrients[String(textArray[0])]!] = Float(textArray[1].replacingOccurrences(of: "%", with: ""))! * Float(item.portion) * Float(item.servingsNumber)
                }
                else {
                    dailyValues[dailyValueNutrients[String(textArray[0])]!]! += Float(textArray[1].replacingOccurrences(of: "%", with: ""))! * Float(item.portion) * Float(item.servingsNumber)
                }
            }
        }
        
        return dailyValues
    }
}
