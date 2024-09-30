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
            if viewModel.item.isFavorite {
                Label {
                    Text(viewModel.item.name)
                    if settings.carbonFootprints && viewModel.item.carbonFootprint > 0 {
                        Spacer()
                        Image(systemName: "leaf")
                            .foregroundStyle(viewModel.carbonFootprintColor)
                    }
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }
            else if settings.filterIngredients && viewModel.containsRestrictions {
                Label {
                    Text(viewModel.item.name)
                    if settings.carbonFootprints && viewModel.item.carbonFootprint > 0 {
                        Spacer()
                        Image(systemName: "leaf")
                            .foregroundStyle(viewModel.carbonFootprintColor)
                    }
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.accent)
                }
            }
            else {
                if viewModel.hasValue {
                    if viewModel.item.amounts[viewModel.nutrient]! == nil {
                        LabeledContent(viewModel.item.name, value: "-")
                    }
                    else {
                        LabeledContent(viewModel.item.name, value: String(viewModel.item.amounts[viewModel.nutrient]!!))
                    }
                }
                else {
                    Text(viewModel.item.name)
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
