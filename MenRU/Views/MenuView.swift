//
//  MenuView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI

struct MenuView: View {
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
    
    @State var place: String
    // automatically sets selectedMeal according to time of day
    @State private var selectedMeal = Calendar.current.component(.hour, from: Date()) < 5 ? (Calendar.current.component(.hour, from: Date()) < 11 ? "Breakfast" : "Lunch") : "Dinner"
    @State private var selectedDate = Date.now
    @State private var group = true
    @State private var menu: FoodMenu = FoodMenu()
    @Environment(Settings.self) private var settings
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(menu.categories) { category in
                    if group {
                        MenuSectionView(category: category)
                    }
                    else {
                        ForEach(category.items.sorted(by: { $0.name < $1.name })) { item in
                            ItemView(item: item)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Meal", selection: $selectedMeal) {
                        ForEach(meals, id: \.self) { meal in
                            Text(meal)
                        }
                    }
                    .onChange(of: selectedMeal) {
                        Task {
                            menu.categories = try! await fetchMenu(place: place, meal: selectedMeal)
                        }
                    }
                    .pickerStyle(.segmented)
                    .fixedSize()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker(selection: $group) {
                            Text("On").tag(true)
                            Text("Off").tag(false)
                        } label: {
                            Button(action: {}) {
                                Text("Group By Category")
                                Text(group ? "On" : "Off")
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .pickerStyle(.menu)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .task {
                if menu.categories.isEmpty {
                    menu.categories = try! await fetchMenu(place: place, meal: selectedMeal)
                }
            }
        }
    }
    
    func fetchMenu(place: String, meal: String) async throws -> [Category] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + places[place]! + "&locationName=" + place.replacingOccurrences(of: " ", with: "+") + "&dtdate=" + dateFormatter.string(from: Date.now) + "&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!)
        let elements = try! doc.select("div.menuBox h3, div.menuBox fieldset div.col-1 label, div.menuBox fieldset div.col-2 label").array()
        
        var menu = [Category]();
        for var i in 0..<elements.count {
            let element = elements[i]
            
            if (element.tagName() == "h3") {
                var heading = String(try! element.text())
                // remove "-- " and " --" from headings and capitalize headings
                heading = String(heading[heading.index(after: heading.firstIndex(of: " ")!)..<heading.lastIndex(of: " ")!]).capitalized
                menu.append(Category(name: heading))
            }
            if (element.tagName() == "label") {
                // check if item is already on the menu
                var duplicate = false
                for category in menu {
                    for item in category.items {
                        if try! item.id == element.attr("for") {
                            duplicate = true;
                            break
                        }
                    }
                    if duplicate {
                        break
                    }
                }
                if (duplicate) {
                    continue
                }
                
                let servingSize = try? Int(elements[i + 1].attr("aria-label").first!.description) ?? 1
                let servingSizeUnit = try? elements[i + 1].attr("aria-label").replacingOccurrences(of: elements[i + 1].attr("aria-label").first!.description, with: "").lowercased()
                
                // capitalize items
                menu[menu.count - 1].items.append(Item(name: try! element.attr("name").capitalized.replacingOccurrences(of: "  ", with: " "), id: try! element.attr("for"), servingSize: servingSize!, servingSizeUnit: servingSizeUnit!, isFavorite: settings.favoriteItemsIDs.contains(try! element.attr("for"))))
            }
        }
        
        return menu;
    }
}
