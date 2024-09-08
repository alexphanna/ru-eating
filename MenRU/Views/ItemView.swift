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
    @State private var restricted: Bool = false
    @Environment(Settings.self) private var settings
    
    var body : some View {
        if (settings.hideRestricted && !restricted) || !settings.hideRestricted {
            NavigationLink {
                NavigationStack {
                    VStack {
                        if item.ingredients.isEmpty {
                            Text("Nutritional information is not available for this item")
                        }
                        else {
                            List {
                                if restricted {
                                    Label("Item Contains Dietary Restrictions", systemImage: "exclamationmark.triangle.fill")
                                }
                                NutritionView(category: Category(name: "", items: [item]))
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
                            Button(action: {
                                item.isFavorite = !item.isFavorite
                                if item.isFavorite {
                                    settings.favoriteItemsIDs.append(item.id)
                                }
                                else if !item.isFavorite {
                                    settings.favoriteItemsIDs.removeAll(where: { $0 == item.id })
                                }
                            }) {
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
                else if settings.filterIngredients && restricted {
                    Label(item.name, systemImage: "exclamationmark.triangle.fill")
                }
                else {
                    Text(item.name)
                }
            }
            .task {
                if item.ingredients.isEmpty {
                    do {
                        item.ingredients = try await fetchIngredients(itemID: item.id)
                        restricted = ingredientsContainRestriction(ingredients: item.ingredients)
                    } catch {
                        // do nothing
                    }
                }
            }
        }
    }
    
    func ingredientsContainRestriction(ingredients: String) -> Bool {
        for restriction in settings.restrictions {
            if ingredients.lowercased().contains(restriction.lowercased()) && item.name.lowercased().contains(restriction.lowercased()) {
                return true
            }
        }
        return false
    }

    func fetchIngredients(itemID: String) async throws -> String {
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + itemID + "*1")!)
        if !hasNutritionalReport(doc: doc) {
            return ""
        }
        let elements = try! doc.select("div.col-md-12 > p").array()
        
        let text = try! elements[0].text()
        let textArray = text.split(separator: "\u{00A0}")
        
        return String(textArray[textArray.count - 1]).capitalized;
    }
}
