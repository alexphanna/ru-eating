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
    
    @State private var items: [Item] = [Item]()
    @State private var searchText = ""
    @State private var searchScope = "Busch"
    
    private var placeNames: [String] {
        return ["Busch", "Livingston", "Neilson", "The Atrium"]
    }
    
    var searchResults: [Item] {
        if (searchText.isEmpty) {
            return items
        }
        else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
        .searchScopes($searchScope, activation: .onSearchPresentation) {
            ForEach(placeNames, id: \.self) { name in
                Text(name)
            }
        }
        .onChange(of: searchScope) {
            Task {
                await updateItems()
            }
        }
    }
    
    func updateItems() async {
        items = [Item]()
        for place in places {
            if !place.name.contains(searchScope) { continue }
            for meal in meals {
                do {
                    let menu = try await place.fetchMenu(meal: meal, date: Date.now, settings: settings)
                    
                    for category in menu {
                        for item in category.items {
                            if !items.contains(item) {
                                items.append(item)
                            }
                        }
                    }
                } catch {
                    // do nothing
                }
            }
            break
        }
    }
}
