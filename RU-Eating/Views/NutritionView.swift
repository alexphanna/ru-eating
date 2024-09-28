//
//  NutritionView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI

struct NutritionView: View {
    @State var viewModel: NutritionViewModel
    @Environment(Settings.self) private var settings
    
    var body: some View {
        Section {
            Picker("Unit", selection: $viewModel.unit) {
                ForEach(["Amounts", "% Daily Values"], id: \.self) { unit in
                    Text(unit)
                }
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            .padding()
            .listRowInsets(EdgeInsets())
            if viewModel.showServingSize {
                LabeledContent("Serving Size", value: viewModel.category.items[0].servingSize)
                    .fontWeight(.bold)
            }
            ForEach(Array(viewModel.values.keys), id: \.self) { key in
                if key == "Calories" {
                    LabeledContent(key, value: String(formatFloat(n: viewModel.values[key]!!)) + (viewModel.unit == "Amounts" ? nutrientUnits[key]! : "%"))
                        .fontWeight(key == "Calories" ? .bold : .regular)
                }
                else {
                    if viewModel.values[key]! == nil && !settings.hideNils {
                        LabeledContent(key, value: "-")
                    }
                    else if viewModel.values[key]! != nil && (viewModel.values[key]!! != 0 || !settings.hideZeros) {
                        // let temp = Float(viewModel.values[key]!!) / Float(dailyValues[key]!)
                        LabeledContent(key, value: formatFloat(n: viewModel.values[key]!!) + (viewModel.unit == "Amounts" ? nutrientUnits[key]! : "%"))
                    }
                }
            }
        } header: {
            Text("Nutrition Facts")
        } footer: {
            Text("Percent Daily Values are based on a 2,000 calorie diet.")
        }
        .onChange(of: viewModel.category.portions) {
            Task {
                await viewModel.updateValues()
            }
        }
        .task {
            await viewModel.updateValues()
        }
    }
}
