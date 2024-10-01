//
//  ItemNavigationLink.swift
//  RU Eating
//
//  Created by alex on 9/25/24.
//

import SwiftUI

struct ItemNavigationLink : View {
    @Bindable var viewModel: ItemViewModel
    @Environment(Settings.self) private var settings
    
    var body: some View {
        NavigationLink {
            ItemView(viewModel: viewModel)
        } label: {
            HStack {
                if viewModel.item.isFavorite || (settings.filterIngredients && viewModel.containsRestrictions) {
                    Label {
                        Text(viewModel.item.name)
                    } icon: {
                        if viewModel.item.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                        else if (settings.filterIngredients && viewModel.containsRestrictions) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.accent)
                        }
                    }
                }
                else {
                    Text(viewModel.item.name)
                }
                if viewModel.sortBy == "Nutrient" {
                    Spacer()
                    if viewModel.item.amounts[viewModel.nutrient]! == nil {
                        Text("-")
                            .foregroundStyle(.gray)
                    }
                    else {
                        Text(String(formatFloat(n: viewModel.item.amounts[viewModel.nutrient]!!)) + nutrientUnits[viewModel.nutrient]!)
                            .foregroundStyle(.gray)
                    }
                }
                else if viewModel.sortBy == "Carbon Footprint" {
                    Spacer()
                    if settings.carbonFootprints && viewModel.item.carbonFootprint > 0 {
                        Image(systemName: "leaf")
                            .imageScale(.medium)
                            .foregroundStyle(viewModel.carbonFootprintColor)
                    }
                }
                else if viewModel.sortBy == "Ingredients" {
                    Spacer()
                    if viewModel.item.ingredientsCount == nil {
                        Text("-")
                            .foregroundStyle(.gray)
                    }
                    else {
                        Text(String(viewModel.item.ingredientsCount!))
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .swipeActions {
            Button(action: { settings.favorite(item: viewModel.item) }) {
                Image(systemName: viewModel.item.isFavorite ? "star.slash.fill" : "star.fill")
            }
            .tint(.yellow)
        }
    }
}
