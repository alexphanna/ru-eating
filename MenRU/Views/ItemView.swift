//
//  ItemView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup
import SwiftData
import OrderedCollections

struct ItemView: View {
    @State var item: Item
    @State private var amounts = OrderedDictionary<String, String>()
    @State private var dailyValues = OrderedDictionary<String, String>()
    @State private var ingredients : String = ""
    @State private var selectedUnit : String = "Amount"
    @State private var servings : Int = 0
    @Environment(Settings.self) private var settings
    
    var body : some View {
        let dict = [
            "Amount" : amounts,
            "Daily Value" : dailyValues
        ]
        
        NavigationLink {
            NavigationStack {
                VStack {
                    if amounts.isEmpty {
                        Text("Nutritional information is not available for this item")
                    }
                    else {
                        List {
                            Section("Nutrition Facts") {
                                Picker("Unit", selection: $selectedUnit) {
                                    ForEach (["Amount", "Daily Value"], id: \.self) { unit in
                                        Text(unit)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .listRowSeparator(.hidden)
                                .padding()
                                .listRowInsets(EdgeInsets())
                                // Stepper("Servings", value: $servings)
                                ForEach(Array(dict[selectedUnit]!.keys), id: \.self) { key in
                                    LabeledContent(key, value: dict[selectedUnit]![key]!)
                                }
                            }
                            Section("Ingredients") {
                                Text(ingredients).font(.footnote).italic().foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .navigationTitle(item.name)
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    amounts = try! await fetchAmounts(itemID: item.id)
                    
                    dailyValues = try! await fetchDailyValues(itemID: item.id)
                }
            }
        } label: {
            if settings.allergic && ingredientsContainAllergy(ingredients: ingredients) {
                Label(item.name, systemImage: "exclamationmark.triangle.fill")
            }
            else {
                Text(item.name)
            }
        }
        .onAppear {
            Task {
                ingredients = try! await fetchIngredients(itemID: item.id)
            }
        }
    }
    
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
    
    func fetchAmounts(itemID: String) async throws -> OrderedDictionary<String, String> {
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + itemID + "*1")!)
        if !hasNutritionalReport(doc: doc) {
            return OrderedDictionary<String, String>()
        }
        let elements = try! doc.select("div#nutritional-info table td, div#nutritional-info p:contains(Calories), div#nutritional-info p:contains(Serving Size)").array()
        
        var amounts = OrderedDictionary<String, String>();
        for element in elements {
            let text = try! element.text()
            if text.contains("Serving Size") {
                amounts["Serving Size"] = String(text.replacingOccurrences(of: "Serving Size ", with: "")).capitalized
                continue
            }
            let textArray = text.split(separator: "\u{00A0}")
            
            if textArray.count != 2 {
                continue
            }
            amounts[amountNutrients[String(textArray[0])]!] = String(textArray[1])
        }
        
        return amounts;
    }
    
    func fetchDailyValues(itemID: String) async throws -> OrderedDictionary<String, String> {
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + itemID + "*1")!)
        if !hasNutritionalReport(doc: doc) {
            return OrderedDictionary<String, String>()
        }
        let elements = try! doc.select("div#nutritional-info ul li").array()
        
        var dailyValues = OrderedDictionary<String, String>();
        for element in elements {
            let text = try! element.text()
            let textArray = text.split(separator: " \u{00A0}\u{00A0}")
            
            if textArray.count != 2 {
                continue
            }
            dailyValues[dailyValueNutrients[String(textArray[0])]!] = String(textArray[1])
        }
        
        return dailyValues
    }
    
    func hasNutritionalReport(doc: Document) -> Bool {
        return try! doc.select("h2:contains(Nutritional Information is not available for this recipe.)").array().count == 0
    }
    
    func ingredientsContainAllergy(ingredients: String) -> Bool {
        for allergy in settings.allergies {
            if ingredients.lowercased().contains(allergy.lowercased()) {
                return true
            }
        }
        return false
    }

    func fetchIngredients(itemID: String) async throws -> String {
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + itemID + "*1")!)
        if !hasNutritionalReport(doc: doc) {
            return ""
        }
        let elements = try! doc.select("div.col-md-12 > p").array()
        
        let text = try! elements[0].text()
        let textArray = text.split(separator: "\u{00A0}")
        
        return String(textArray[textArray.count - 1]).capitalized;
    }

}
