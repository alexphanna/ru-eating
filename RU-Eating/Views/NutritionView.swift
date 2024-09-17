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
    @State var showServingSize: Bool = false
    @State private var amounts = OrderedDictionary<String, Float>()
    @State private var dailyValues = OrderedDictionary<String, Float>()
    @State private var selectedUnit : String = "Amount"
    @State private var servings : Int = 0
    
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
            if showServingSize {
                LabeledContent("Serving Size", value: category.items[0].servingSize)
                    .fontWeight(.bold)
            }
            ForEach(Array(dict[selectedUnit]!.keys), id: \.self) { key in
                if selectedUnit == "Amount" {
                    if key == "Calories" {
                        LabeledContent(key, value: String(formatFloat(n: dict[selectedUnit]![key]!)) + nutrientUnits[key]!)
                            .fontWeight(key == "Calories" ? .bold : .regular)
                    }
                    else {
                        LabeledContent(key, value: String(formatFloat(n: dict[selectedUnit]![key]!)) + nutrientUnits[key]!)
                    }
                }
                else if selectedUnit == "Daily Value" {
                    LabeledContent(key, value: String(formatFloat(n: dict[selectedUnit]![key]!)) + "%")
                }
            }
        } header: {
            Text("Nutrition Facts")
        } footer: {
            Text("Percent Daily Values are based on a 2,000 calorie diet.")
        }
        .onChange(of: category.portions) {
            Task {
                await updateValues()
            }
        }
        .task {
            await updateValues()
        }
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
