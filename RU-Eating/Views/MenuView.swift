//
//  MenuView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI

struct MenuView: View {
    @State var place: Place
    // automatically sets selectedMeal according to time of day
    @State private var selectedMeal = Calendar.current.component(.hour, from: Date()) < 17 ? (Calendar.current.component(.hour, from: Date()) < 11 ? "Breakfast" : "Lunch") : "Dinner"
    @State private var showDatePicker = false
    @State private var selectedDate = Date.now
    @State private var group = true
    @State private var menu: [Category] = [Category]()
    @Environment(Settings.self) private var settings
    
    @State private var searchText = ""
    @State private var selectedFilter: String = "All Items"
    
    private var filteredMenu: [Category] {
        var filteredMenu: [Category] = [Category]()
        
        for category in menu {
            let filteredCategory: Category = Category(name: category.name)
            
            switch selectedFilter {
            case "Favorites":
                filteredCategory.items.append(contentsOf: category.items.filter { $0.isFavorite })
                break
            default:
                filteredCategory.items.append(contentsOf: category.items)
                break
            }
            
            if !searchText.isEmpty {
                let searchedCategory: Category = Category(name: category.name)
                
                for item in filteredCategory.items {
                    if item.name.lowercased().contains(searchText.lowercased()) {
                        searchedCategory.items.append(item)
                    }
                }
                
                if !searchedCategory.items.isEmpty {
                    filteredMenu.append(searchedCategory)
                }
            }
            else if !filteredCategory.items.isEmpty {
                filteredMenu.append(filteredCategory)
            }
        }
        
        return filteredMenu
    }
    
    private var items: Category {
        let category: Category = Category(name: "All")
        
        for _category in filteredMenu {
            category.items.append(contentsOf: _category.items)
        }
        
        category.items = category.items.sorted(by: { $0.name < $1.name })
        
        return category
    }
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                List {
                    if showDatePicker {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .onChange(of: selectedDate) {
                                showDatePicker = false
                                Task {
                                    await updateMenu()
                                }
                            }
                    }
                    if group {
                        ForEach(filteredMenu) { category in
                            CategoryView(category: category, searchText: $searchText)
                        }
                    }
                    else {
                        CategoryView(category: items, searchText: $searchText)
                    }
                }
                .searchable(text: $searchText)
                .overlay {
                    if !searchText.isEmpty && filteredMenu.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    }
                    else if menu.isEmpty {
                        ProgressView()
                    }
                    else if filteredMenu.isEmpty {
                        ContentUnavailableView("No Results", systemImage: "")
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
                                await updateMenu()
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showDatePicker.toggle() }) {
                            Image(systemName: "calendar")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Section {
                                Picker(selection: $selectedFilter ) {
                                    Section {
                                        Label("All Items", systemImage: "fork.knife").tag("All Items")
                                    }
                                    Section {
                                        Label("Favorites", systemImage: "star").tag("Favorites")
                                    }
                                } label: {
                                    Button(action: {}) {
                                        HStack {
                                            Text("Filter")
                                            Spacer()
                                            Image(systemName: selectedFilter == "All Items" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                                        }
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            Section {
                                Picker(selection: $group) {
                                    Text("On").tag(true)
                                    Text("Off").tag(false)
                                } label: {
                                    Button(action: {}) {
                                        HStack {
                                            VStack {
                                                Text("Group By Category")
                                                Text(group ? "On" : "Off")
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                                
                                            }
                                            Spacer()
                                            Image(systemName: "rectangle.3.group")
                                        }
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .task {
                    if menu.isEmpty {
                        await updateMenu()
                    }
                }
            }
        } label: {
            VStack (alignment: HorizontalAlignment.leading) {
                Text(place.name)
                Text(place.campus).font(.footnote).italic().foregroundStyle(.gray)
            }
        }
    }
    
    func updateMenu() async {
        do {
            // clear menu first, to show progress view
            menu = [Category]()
            menu = try await place.fetchMenu(meal: selectedMeal, date: selectedDate, settings: settings)
        } catch {
            print(error)
        }
    }
}
