//
//  ContentView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

let places = [
    "Busch Dining Hall" : "04",
    "Livingston Dining Commons" : "03",
    "Neilson Dining Hall" : "05",
    "The Atrium" : "13"
]
let campuses = [
    "Busch Dining Hall" : "Busch",
    "Livingston Dining Commons" : "Livingston",
    "Neilson Dining Hall" : "Cook/Douglass",
    "The Atrium" : "College Ave"
]
let placesShortened = [
    "Busch Dining Hall" : "Busch",
    "Livingston Dining Commons" : "Livingston",
    "Neilson Dining Hall" : "Neilson",
    "The Atrium" : "The Atrium"
];
let meals = [
    "Breakfast",
    "Lunch",
    "Dinner"
]

struct ContentView: View {
    @State private var menu : [Category] = [Category]()
    @State private var selectedMeal = "Breakfast"
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(places.keys), id: \.self) { place in
                    NavigationLink {
                        VStack {
                            Picker("Meal", selection: $selectedMeal) {
                                ForEach(meals, id: \.self) { meal in
                                    Text(meal)
                                }
                            }
                            .onChange(of: selectedMeal) {
                                Task {
                                    menu = try! await fetchMenu(place: place, meal: selectedMeal)
                                }
                            }
                            .pickerStyle(.segmented)
                            .fixedSize()
                            List {
                                ForEach(menu) { category in
                                    Section(header: Text(category.name)) {
                                        ForEach(category.items) { item in
                                            Text(item.name)
                                        }
                                    }
                                }
                            }
                            .navigationTitle(placesShortened[place]! + " Menu")
                        }
                        .task {
                            menu = try! await fetchMenu(place: place, meal: selectedMeal)
                        }
                    } label: {
                        VStack (alignment: HorizontalAlignment.leading) {
                            Text(place)
                            Text(campuses[place]!).font(.footnote).italic().foregroundStyle(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Dining Halls")
        }
    }
    
    struct Category : Hashable, Identifiable {
        let name : String
        var items : [Item]
        let id = UUID()
    }
    
    struct Item : Hashable, Identifiable {
        let name : String
        let id = UUID()
    }
    
    func fetchMenu(place: String, meal: String) async throws -> [Category] {
        let url = URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + places[place]! + "&locationName=" + place.replacingOccurrences(of: " ", with: "+") + "&dtdate=09/06/2024&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        
        let elements = try! doc.select("div.menuBox h3, div.menuBox fieldset div.col-1 label").array()
        
        var menu = [Category]();
        for element in elements {
            if (element.tagName() == "h3") {
                var heading = String(try! element.text())
                // remove "-- " and " --" from headings and capitalize headings
                heading = String(heading[heading.index(after: heading.firstIndex(of: " ")!)..<heading.lastIndex(of: " ")!]).capitalized
                menu.append(Category(name: heading, items: []))
            }
            if (element.tagName() == "label") {
                // capitalize items
                menu[menu.count - 1].items.append(Item(name: try! element.attr("name").capitalized))
            }
        }
        
        // remove duplicate items
        return menu;
    }
}

#Preview {
    ContentView()
}
