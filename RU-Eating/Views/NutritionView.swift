//
//  NutritionView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI

struct NutritionView: View {
    @State var viewModel: NutritionViewModel
    
    var body: some View {
        if !viewModel.values.isEmpty {
            Section {
                Picker("Unit", selection: $viewModel.unit) {
                    ForEach(["Amount", "Daily Value"], id: \.self) { unit in
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
                    if viewModel.unit == "Amount" {
                        if key == "Calories" {
                            LabeledContent(key, value: String(formatFloat(n: viewModel.values[key]!)) + nutrientUnits[key]!)
                                .fontWeight(key == "Calories" ? .bold : .regular)
                        }
                        else {
                            LabeledContent(key, value: String(formatFloat(n: viewModel.values[key]!)) + nutrientUnits[key]!)
                        }
                    }
                    else if viewModel.unit == "Daily Value" {
                        LabeledContent(key, value: String(formatFloat(n: viewModel.values[key]!)) + "%")
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
}
