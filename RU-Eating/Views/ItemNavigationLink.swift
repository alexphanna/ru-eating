//
//  ItemNavigationLink.swift
//  RU Eating
//
//  Created by alex on 9/25/24.
//

import SwiftUI

struct ItemNavigationLink : View {
    @State var viewModel: ItemViewModel
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
            else if settings.filterIngredients && viewModel.restricted {
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
                HStack {
                    Text(viewModel.item.name)
                    if settings.carbonFootprints && viewModel.item.carbonFootprint > 0 {
                        Spacer()
                        Image(systemName: "leaf")
                            .foregroundStyle(viewModel.carbonFootprintColor)
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
        .task {
            await viewModel.updateItem()
        }
    }
}
