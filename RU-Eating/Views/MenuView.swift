//
//  MenuView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI

struct MenuView: View {
    @State var viewModel: MenuViewModel
    @Environment(Settings.self) private var settings
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                List {
                    if viewModel.groupByCategory {
                        ForEach(viewModel.menu, id: \.self) { category in
                            CategoryView(viewModel: CategoryViewModel(category: category, nutrient: viewModel.nutrient, sortBy: viewModel.sortBy, sortOrder: viewModel.sortOrder, isEditing: viewModel.isEditing))
                        }
                    }
                    else {
                        CategoryView(viewModel: CategoryViewModel(category: viewModel.items, nutrient: viewModel.nutrient, sortBy: viewModel.sortBy, sortOrder: viewModel.sortOrder, isExpandable: false, isEditing: viewModel.isEditing))
                    }
                }
                .safeAreaInset(edge: .top) {
                    if !viewModel.isEditing {
                        VStack(spacing: -1) {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .frame(height: 66)
                                .overlay {
                                    HStack {
                                        Button(action: viewModel.decrementDate) {
                                            Image(systemName: "chevron.left.circle.fill")
                                                .imageScale(.large)
                                                .foregroundStyle(.accent)
                                        }
                                        Spacer()
                                        Text(viewModel.dateText)
                                        Spacer()
                                        Button(action: viewModel.incrementDate) {
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
                }
                .overlay {
                    if viewModel.rawMenu.isEmpty && !viewModel.fetched {
                        ProgressView()
                    }
                    else if viewModel.rawMenu.isEmpty && viewModel.fetched {
                        ContentUnavailableView {
                            Text("No Items")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                    }
                    else if viewModel.menu.isEmpty {
                        ContentUnavailableView("No Results", systemImage: "")
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(viewModel.isEditing)
                .toolbar(viewModel.isEditing ? .hidden : .visible, for: .tabBar)
                .toolbar {
                    if viewModel.isEditing {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                withAnimation(.easeInOut) {
                                    viewModel.isEditing = false
                                }
                            }
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            Button("Copy") {
                                UIPasteboard.general.string = viewModel.selectedItemsNames.joined(separator: "\n")
                                withAnimation(.easeInOut) {
                                    viewModel.isEditing = false
                                }
                            }
                        }
                    }
                    else {
                        ToolbarItem(placement: .principal) {
                            Picker("Meal", selection: $viewModel.meal) {
                                ForEach(viewModel.place.hasTakeout ? meals + ["Takeout"] : meals, id: \.self) { meal in
                                    Text(meal)
                                }
                            }
                            .onChange(of: viewModel.meal) {
                                Task {
                                    await viewModel.updateMenu()
                                }
                            }
                            .pickerStyle(.segmented)
                            .fixedSize()
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Section {
                                    if viewModel.randomItem != nil {
                                        NavigationLink {
                                            ItemView(viewModel: ItemViewModel(item: viewModel.randomItem!, nutrient: viewModel.sortBy, sortBy: viewModel.sortBy, settings: settings, isEditing: viewModel.isEditing))
                                                .onAppear {
                                                    viewModel.randomItem = viewModel.items.items.randomElement() // update random element
                                                }
                                        } label: {
                                            Label("Random Item", systemImage: "dice")
                                        }
                                    }
                                    Button("Select Items", systemImage: "checkmark.circle", action: { viewModel.isEditing.toggle() })
                                    Picker(selection: $viewModel.filter ) {
                                        Section {
                                            Label("All Items", systemImage: "fork.knife").tag("All Items")
                                        }
                                        Section {
                                            Label("Favorites", systemImage: "star").tag("Favorites")
                                            Label("Low Carbon Footprint", systemImage: "leaf").tag("Low Carbon Footprint")
                                        }
                                    } label: {
                                        Label("Filter", systemImage: viewModel.filter == "All Items" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                                        Text(viewModel.filter)
                                    }
                                    .pickerStyle(.menu)
                                    Menu {
                                        Section {
                                            Picker("", selection: $viewModel.sortBy) {
                                                Text("None").tag("None")
                                                Text("Name").tag("Name")
                                                Text("Carbon Footprint").tag("Carbon Footprint")
                                                if viewModel.fetched {
                                                    Text("Nutrient").tag("Nutrient")
                                                    Text("Ingredients").tag("Ingredients")
                                                }
                                            }
                                        }
                                        Section {
                                            Picker("", selection: $viewModel.sortOrder) {
                                                ForEach(["Ascending", "Descending"], id: \.self) {
                                                    Text($0)
                                                }
                                            }
                                        }
                                    } label: {
                                        Label("Sort By" , systemImage: "arrow.up.arrow.down")
                                        Text(viewModel.sortBy)
                                    }
                                    .pickerStyle(.inline)
                                    Picker(selection: $viewModel.groupByCategory ) {
                                        Text("On")
                                            .tag(true)
                                        Text("Off")
                                            .tag(false)
                                    } label: {
                                        Label("Group By Category", systemImage: "list.bullet.below.rectangle")
                                        Text(viewModel.groupByCategory ? "On" : "Off")
                                    }
                                    .pickerStyle(.menu)
                                }
                                Link(destination: viewModel.place.getURL(meal: viewModel.meal, date: viewModel.date), label: {
                                    Label("View Source", systemImage: "link")
                                })
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        if viewModel.menu.isEmpty {
                            await viewModel.updateMenu()
                        }
                    }
                }
            }
        } label: {
            VStack (alignment: HorizontalAlignment.leading) {
                Text(viewModel.place.name)
                Text(viewModel.place.campus).font(.footnote).italic().foregroundStyle(.gray)
            }
        }
    }
}
