//
//  NutritionView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI
import OrderedCollections

struct NutritionView: View {
    @Bindable var category: Category
    @State private var amounts = OrderedDictionary<String, Float>()
    @State private var dailyValues = OrderedDictionary<String, Float>()
    @State private var selectedUnit : String = "Amount"
    @State private var servings : Int = 0
    
    let nutrientUnits = [
        "Calories" : "",
        "Fat" : "g",
        "Carbohydrates" : "g",
        "Saturated Fat" : "g",
        "Dietary Fiber" : "g",
        "Trans Fat" : "g",
        "Sugars" : "g",
        "Cholesterol" : "mg",
        "Protein" : "g",
        "Sodium" : "mg"
    ]
    
    var body: some View {
        let dict = [
            "Amount" : amounts,
            "Daily Value" : dailyValues
        ]
        
        Section {
            Picker("Unit", selection: $selectedUnit) {
                ForEach(["Amount", "Daily Value"], id: \.self) { unit in
                    Text(unit)
                }
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            .padding()
            .listRowInsets(EdgeInsets())
            // Stepper("Servings", value: $servings)
            ForEach(Array(dict[selectedUnit]!.keys), id: \.self) { key in
                if selectedUnit == "Amount" {
                    LabeledContent(key, value: String(dict[selectedUnit]![key]!.formatted(.number.precision(.fractionLength(1)))) + nutrientUnits[key]!)
                }
                else if selectedUnit == "Daily Value" {
                    LabeledContent(key, value: String(dict[selectedUnit]![key]!.formatted(.number.precision(.fractionLength(0)))) + "%")
                }
            }
        } header: {
            Text("Nutrition Facts")
        } footer: {
            Text("Percent Daily Values are based on a 2,000 calorie diet.")
        }
        .onChange(of: category.portions) {
            Task {
                amounts = try! await fetchAmounts(items: category.items)
                dailyValues = try! await fetchDailyValues(items: category.items)
            }
        }
        .task {
            amounts = try! await fetchAmounts(items: category.items)
            dailyValues = try! await fetchDailyValues(items: category.items)
        }
    }
    
    func fetchAmounts(items: [Item]) async throws -> OrderedDictionary<String, Float> {
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
                return OrderedDictionary<String, Float>()
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
                    amounts[amountNutrients[String(textArray[0])]!] = Float(textArray[1].replacingOccurrences(of: nutrientUnits[amountNutrients[String(textArray[0])]!]!, with: ""))! * Float(item.portion)
                }
                else {
                    amounts[amountNutrients[String(textArray[0])]!]! += Float(textArray[1].replacingOccurrences(of: nutrientUnits[amountNutrients[String(textArray[0])]!]!, with: ""))! * Float(item.portion)
                }
            }
        }
        
        return amounts;
    }
    
    func fetchDailyValues(items: [Item]) async throws -> OrderedDictionary<String, Float> {
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
                return OrderedDictionary<String, Float>()
            }
            let elements = try! doc.select("div#nutritional-info ul li").array()
            
            for element in elements {
                let text = try! element.text()
                let textArray = text.split(separator: " \u{00A0}\u{00A0}")
                
                if textArray.count != 2 {
                    continue
                }
                if dailyValues[dailyValueNutrients[String(textArray[0])]!] == nil {
                    dailyValues[dailyValueNutrients[String(textArray[0])]!] = Float(textArray[1].replacingOccurrences(of: "%", with: ""))! * Float(item.portion)
                }
                else {
                    dailyValues[dailyValueNutrients[String(textArray[0])]!]! += Float(textArray[1].replacingOccurrences(of: "%", with: ""))! * Float(item.portion)
                }
            }
        }
        
        return dailyValues
    }
}
