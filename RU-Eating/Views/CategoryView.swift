//
//  MenuSectionView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct CategoryView : View {
    @Bindable var viewModel: CategoryViewModel
    @Environment(Settings.self) private var settings
    
    var body : some View {
        if viewModel.isExpandable {
            Section(
                isExpanded: $viewModel.isExpanded,
                content: {
                    ForEach(viewModel.sortedItems) { item in
                        ItemNavigationLink(viewModel: ItemViewModel(item: item, nutrient: viewModel.nutrient, hasValue: viewModel.sortBy == "Nutrient", settings: settings))
                    }
                },
                header: { Text(viewModel.category.name) })
        }
        else {
            Section(content: {
                ForEach(viewModel.sortedItems) { item in
                    ItemNavigationLink(viewModel: ItemViewModel(item: item, nutrient: viewModel.nutrient, hasValue: viewModel.sortBy == "Nutrient", settings: settings))
                }
            }, header: {
                HStack {
                    Text("Name")
                    if viewModel.sortBy == "Nutrient" {
                        Spacer()
                        Button(viewModel.nutrient, action: viewModel.nextNutrient )
                            .font(.caption)
                    }
                }
            })
        }
    }
}
