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
    @State private var selectedDate = Date.now
    @State private var group = true
    @State var menu: [Category] = [Category]()
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
            case "Low Carbon Footprint":
                filteredCategory.items.append(contentsOf: category.items.filter { $0.carbonFootprint == 1 })
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
    
    private let days = [
        Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!) : "Yesterday",
        Calendar.current.dateComponents([.year, .month, .day], from: Date.now) : "Today",
        Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!) : "Tomorrow"
    ]
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                List {
                    if group {
                        ForEach(filteredMenu) { category in
                            CategoryView(category: category, searchText: $searchText)
                        }
                    }
                    else {
                        CategoryView(category: items, searchText: $searchText)
                    }
                }
                .safeAreaInset(edge: .top) {
                    VStack(spacing: -1) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .frame(height: 66)
                            .overlay {
                                HStack {
                                    Button(action: {
                                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!;
                                        Task {
                                            await updateMenu()
                                        }
                                    }) {
                                        Image(systemName: "chevron.left.circle.fill")
                                            .imageScale(.large)
                                            .foregroundStyle(.accent)
                                    }
                                    Spacer()
                                    Text("\(days[Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)] ?? selectedDate.formatted(Date.FormatStyle().weekday(.wide))), \(selectedDate.formatted(Date.FormatStyle().month(.wide))) \(selectedDate.formatted(Date.FormatStyle().day()))")
                                    Spacer()
                                    Button(action: {
                                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                                        Task {
                                            await updateMenu()
                                        }
                                    }) {
                                        Image(systemName: "chevron.right.circle.fill")
                                            .imageScale(.large)
                                            .foregroundStyle(.accent)
                                    }
                                }
                                .padding(30)
                            }
                        Divider()
                    }
                }
                //.searchable(text: $searchText)
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
                            ForEach(place.hasTakeout ? meals + ["Takeout"] : meals, id: \.self) { meal in
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
                        Menu {
                            Section {
                                Picker(selection: $selectedFilter ) {
                                    Section {
                                        Label("All Items", systemImage: "fork.knife").tag("All Items")
                                    }
                                    Section {
                                        Label("Favorites", systemImage: "star").tag("Favorites")
                                        Label("Low Carbon Footprint", systemImage: "leaf").tag("Low Carbon Footprint")
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
                            Link(destination: place.getURL(meal: selectedMeal, date: selectedDate), label: {
                                Label("View Source", systemImage: "link")
                            })
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
            menu = try await place.fetchMenu(meal: selectedMeal == "Takeout" ? "Knight+Room" : selectedMeal, date: selectedDate, settings: settings)
        } catch {
            print(error)
        }
    }
}
