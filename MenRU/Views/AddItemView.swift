//
//  ItemsView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct AddItemsView : View {
    @Environment(\.dismiss) var dismiss
    @Environment(Settings.self) private var settings
    @State var meal: Category
    
    @State private var items = OrderedSet<Item>()
    @State private var searchText = ""
    
    var searchResults: [Item] {
        if (searchText.isEmpty) {
            return Array(items)
        }
        else {
            return Array(items).filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body : some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { item in
                    if !meal.items.contains(item) {
                        Button(item.name) {
                            meal.items.append(item)
                            dismiss()
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .task {
                do {
                    try await fetchItems()
                } catch is CancellationError {
                    print("task cancelled")
                } catch {
                    print("\(error)")
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    func fetchItems() async throws {
        for place in places {
            for meal in meals {
                let url = place.getURL(meal: meal)
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
                
                let labels = try! doc.select("div.menuBox fieldset div.col-1 label").array()
                let servings = try! doc.select("div.menuBox fieldset div.col-2 label").array()
                
                for i in 0..<labels.count {
                    let label = labels[i]
                    let serving = servings[i]
                    
                    let servingsNumber = try? Int(serving.attr("aria-label").first!.description) ?? 1
                    let servingsUnit = try? serving.attr("aria-label").replacingOccurrences(of: String(servingsNumber!), with: "").lowercased()
                    // capitalize items
                    items.append(Item(name: try! label.attr("name").capitalized.replacingOccurrences(of: "  ", with: " "), id: try! label.attr("for"), servingsNumber: servingsNumber!, servingsUnit: servingsUnit!, isFavorite: settings.favoriteItemsIDs.contains(try! label.attr("for"))))
                }
            }
        }
    }
}
