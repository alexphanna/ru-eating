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
    @State private var menu: [Category] = [Category]()
    @Environment(Settings.self) private var settings
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                List {
                    ForEach(menu, id: \.self) { category in
                        if group {
                            CategoryView(category: category)
                        }
                        else {
                            ForEach(category.items.sorted(by: { $0.name < $1.name })) { item in
                                if (settings.hideUnfavorited && item.isFavorite) || !settings.hideUnfavorited {
                                    ItemView(item: item)
                                }
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
                                menu = try! await place.fetchMenu(meal: selectedMeal, settings: settings)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Section {
                                Button(action: { settings.hideUnfavorited = !settings.hideUnfavorited }) {
                                    HStack {
                                        Text(settings.hideUnfavorited ? "Show Unfavorited" : "Hide Unfavorited")
                                        Spacer()
                                        Image(systemName: settings.hideUnfavorited ? "eye" : "eye.slash")
                                    }
                                }
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
                        menu = try! await place.fetchMenu(meal: selectedMeal, settings: settings)
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
}
