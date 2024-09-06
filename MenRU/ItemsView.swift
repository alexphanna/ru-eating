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
    
    @State private var items : Set<String> = Set<String>()
    @State private var searchText = ""
    
    var searchResults: [String] {
        if (searchText.isEmpty) {
            return Array(items).sorted()
        }
        else {
            return Array(items).sorted().filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body : some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { item in
                    Text(item)
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
    
    func fetchItems() async throws -> Set<String> {
        var items: Set = Set<String>()
        for place in Array(places.keys) {
            for meal in meals {
                let url = URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + places[place]! + "&locationName=" + place.replacingOccurrences(of: " ", with: "+") + "&dtdate=09/06/2024&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
                
                let labels = try! doc.select("div.menuBox fieldset div.col-1 label").array()
                
                var menu = [Category]();
                for label in labels {
                    // capitalize items
                    items.insert(try! label.attr("name").capitalized)
                }
            }
        }
        
        return items
    }
}
