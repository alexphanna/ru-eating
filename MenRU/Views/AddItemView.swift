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
    
    let places = [
        "Busch Dining Hall" : "04",
        "Livingston Dining Commons" : "03",
        "Neilson Dining Hall" : "05",
        "The Atrium" : "13"
    ]
    let meals = [
        "Breakfast",
        "Lunch",
        "Dinner"
    ]
    
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
        for place in Array(places.keys) {
            for meal in meals {
                let url = URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + places[place]! + "&locationName=" + place.replacingOccurrences(of: " ", with: "+") + "&dtdate=09/06/2024&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
                
                let labels = try! doc.select("div.menuBox fieldset div.col-1 label").array()
                let servings = try! doc.select("div.menuBox fieldset div.col-2 label").array()
                
                for i in 0..<labels.count {
                    let label = labels[i]
                    let serving = servings[i]
                    
                    let servingSize = try? Int(serving.attr("aria-label").first!.description) ?? 1
                    let servingSizeUnit = try? serving.attr("aria-label").replacingOccurrences(of: serving.attr("aria-label").first!.description + " ", with: "").lowercased()
                    // capitalize items
                    items.append(Item(name: try! label.attr("name").capitalized, id: try! label.attr("for"), servingSize: servingSize!, servingSizeUnit: servingSizeUnit!, isFavorite: settings.favoriteItemsIDs.contains(try! label.attr("for"))))
                }
            }
        }
    }
}
