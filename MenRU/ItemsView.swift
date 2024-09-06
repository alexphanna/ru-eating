//
//  ItemsView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct ItemsView : View {
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
    
    @State private var items : Set<Item> = Set<Item>()
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
                    NavigationLink {
                        ItemView(item: item)
                    } label: {
                        Text(item.name)
                    }
                }
            }
            .task {
                do {
                    items = try await fetchItems()
                } catch is CancellationError {
                    print("task cancelled")
                } catch {
                    print("\(error)")
                }
            }
        }
        .navigationTitle("Items")
        .searchable(text: $searchText)
    }
    
    func fetchItems() async throws -> Set<Item> {
        var items: Set = Set<Item>()
        for place in Array(places.keys) {
            for meal in meals {
                let url = URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + places[place]! + "&locationName=" + place.replacingOccurrences(of: " ", with: "+") + "&dtdate=09/06/2024&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
                
                let labels = try! doc.select("div.menuBox fieldset div.col-1 label").array()
                
                for label in labels {
                    // capitalize items
                    items.insert(Item(name: try! label.attr("name").capitalized, id: try! label.attr("for")))
                }
            }
        }
        
        return items
    }
}
