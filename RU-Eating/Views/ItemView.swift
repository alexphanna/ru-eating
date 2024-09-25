//
//  ItemView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup
import SwiftData

struct ItemView: View {
    @State var viewModel: ItemViewModel
    @Environment(Settings.self) private var settings
    
    var body : some View {
        if (settings.hideRestricted && !viewModel.item.restricted) || !settings.hideRestricted {
            NavigationLink {
                NavigationStack {
                    VStack {
                        if viewModel.item.ingredients.isEmpty {
                            Text("Nutritional information is not available for this item")
                        }
                        else {
                            List {
                                if viewModel.item.restricted {
                                    Section("Warning") {
                                        Label("Item may contain dietary restrictions.", systemImage: "exclamationmark.triangle.fill")
                                    }
                                }
                                NutritionView(category: Category(name: "", items: [viewModel.item]), showServingSize: true)
                                Section("Ingredients") {
                                    Text(viewModel.item.ingredients).font(.footnote).italic().foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text(viewModel.item.name)
                                    .font(.headline)
                                if settings.carbonFootprints && viewModel.item.carbonFootprint > 0 {
                                    Image(systemName: "leaf")
                                        .imageScale(.medium)
                                        .foregroundStyle(viewModel.carbonFootprintColor)
                                }
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            // toggle was changing background color, so I use button
                            Button(action: { settings.favorite(item: viewModel.item) }) {
                                Image(systemName: viewModel.item.isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                }
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
                else if settings.filterIngredients && viewModel.item.restricted {
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
}
