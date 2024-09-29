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
        if (settings.hideRestricted /*&& !viewModel.contains*/) || !settings.hideRestricted {
            NavigationStack {
                VStack {
                    if viewModel.item.ingredients.isEmpty {
                        Text("Nutritional information is not available for this item")
                    }
                    else {
                        List {
                            if viewModel.containsRestrictions {
                                Section("Warning") {
                                    Label("Item may contain dietary restrictions.", systemImage: "exclamationmark.triangle.fill")
                                }
                            }
                            NutritionView(viewModel: NutritionViewModel(category: Category(name: "", items: [viewModel.item]), showServingSize: true, settings: settings))
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
        }
    }
}
