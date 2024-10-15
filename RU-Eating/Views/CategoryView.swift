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
                        ItemNavigationLink(viewModel: ItemViewModel(item: item, nutrient: viewModel.nutrient, sortBy: viewModel.sortBy, settings: settings, isEditing: viewModel.isEditing))
                    }
                },
                header: {
                    HStack {
                        Text(viewModel.category.name)
                        if viewModel.sortBy == "Nutrient" {
                            Spacer()
                            Button(viewModel.nutrient, action: viewModel.nextNutrient )
                                .font(.caption)
                        }
                    }
                })
        }
        else {
            Section(content: {
                ForEach(viewModel.sortedItems) { item in
                    ItemNavigationLink(viewModel: ItemViewModel(item: item, nutrient: viewModel.nutrient, sortBy: viewModel.sortBy, settings: settings, isEditing: viewModel.isEditing))
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
