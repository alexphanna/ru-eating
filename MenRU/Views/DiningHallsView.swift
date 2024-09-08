//
//  DiningHallView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct DiningHallsView : View {
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

    @State private var menu : [Category] = [Category]()
    @State private var selectedMeal = "Breakfast"
    @State private var selectedDate = Date.now
    @State private var isShowingSheet = false
    @Environment(Settings.self) private var settings
    
    var body : some View {
        NavigationStack {
            List {
                ForEach(Array(places.keys).sorted(), id: \.self) { place in
                    NavigationLink {
                        List {
                            ForEach(menu) { category in
                                MenuSectionView(category: category)
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
                                        menu = try! await fetchMenu(place: place, meal: selectedMeal)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .fixedSize()
                            }
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isShowingSheet = true }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .sheet(isPresented: $isShowingSheet, content: {
                SettingsView(settings: settings)
            })
        }
    }
    
    func fetchMenu(place: String, meal: String) async throws -> [Category] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + places[place]! + "&locationName=" + place.replacingOccurrences(of: " ", with: "+") + "&dtdate=" + dateFormatter.string(from: Date.now) + "&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!)
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
                
                // capitalize items
                menu[menu.count - 1].items.append(Item(name: try! element.attr("name").capitalized, id: try! element.attr("for")))
            }
        }
        
        return menu;
    }
}
