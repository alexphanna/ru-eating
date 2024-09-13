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
    @State var item: Item
    @Binding var searchText: String
    @Environment(Settings.self) private var settings
    
    var body : some View {
        if (settings.hideRestricted && !item.restricted) || !settings.hideRestricted {
            NavigationLink {
                NavigationStack {
                    VStack {
                        if item.ingredients.isEmpty {
                            Text("Nutritional information is not available for this item")
                        }
                        else {
                            List {
                                if item.restricted {
                                    Section("Warning") {
                                        Label("Item may contain dietary restrictions.", systemImage: "exclamationmark.triangle.fill")
                                    }
                                }
                                NutritionView(category: Category(name: "", items: [item]), showServingSize: true)
                                Section("Ingredients") {
                                    Text(item.ingredients).font(.footnote).italic().foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .navigationTitle(item.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            // toggle was changing background color, so I use button
                            Button(action: { settings.favorite(item: item) }) {
                                Image(systemName: item.isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                }
            } label: {
                if item.isFavorite {
                    Label {
                        Text(item.name)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                else if settings.filterIngredients && item.restricted {
                    Label(item.name, systemImage: "exclamationmark.triangle.fill")
                }
                else {
                    Text(item.name)
                }
            }
            .swipeActions {
                Button(action: { settings.favorite(item: item) }) {
                    Image(systemName: item.isFavorite ? "star.slash.fill" : "star.fill")
                }
                .tint(.yellow)
            }
            .task {
                if item.ingredients.isEmpty {
                    do {
                        item.ingredients = try await item.fetchIngredients()
                        item.restricted = ingredientsContainRestriction(ingredients: item.ingredients)
                    } catch {
                        // do nothing
                    }
                }
            }
        }
    }
    
    func ingredientsContainRestriction(ingredients: String) -> Bool {
        for restriction in settings.restrictions {
            if ingredients.lowercased().contains(restriction.lowercased()) || item.name.lowercased().contains(restriction.lowercased()) {
                return true
            }
        }
        return false
    }
}
