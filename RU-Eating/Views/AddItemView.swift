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
                await updateItems()
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
    
    func updateItems() async {
        for place in places {
            for meal in meals {
                let menu = try! await place.fetchMenu(meal: meal, date: Date.now, settings: settings)
                
                for category in menu {
                    items.append(contentsOf: category.items)
                }
            }
        }
    }
}
