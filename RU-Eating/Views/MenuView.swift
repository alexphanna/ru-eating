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
                    if viewModel.isGrouped {
                        ForEach(viewModel.menu) { category in
                            CategoryView(viewModel: CategoryViewModel(category: category, searchText: viewModel.searchText))
                        }
                    }
                    else {
                        CategoryView(viewModel: CategoryViewModel(category: viewModel.items, searchText: viewModel.searchText))
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
                .overlay {
                    if !viewModel.searchText.isEmpty && viewModel.menu.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchText)
                    }
                    else if viewModel.rawMenu.isEmpty {
                        ProgressView()
                    }
                    else if viewModel.menu.isEmpty {
                        ContentUnavailableView("No Results", systemImage: "")
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
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
                                Button(action: {}) {
                                    Label("Random Item", systemImage: "dice")
                                }
                                Picker(selection: $viewModel.filter ) {
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
                                            Image(systemName: viewModel.filter == "All Items" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                                        }
                                    }
                                }
                                .pickerStyle(.menu)
                                Picker(selection: $viewModel.isGrouped) {
                                    Text("On").tag(true)
                                    Text("Off").tag(false)
                                } label: {
                                    Button(action: {}) {
                                        HStack {
                                            VStack {
                                                Text("Group By Category")
                                                Text(viewModel.isGrouped ? "On" : "Off")
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
                            Link(destination: viewModel.place.getURL(meal: viewModel.meal, date: viewModel.date), label: {
                                Label("View Source", systemImage: "link")
                            })
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .task {
                    if viewModel.menu.isEmpty {
                        await viewModel.updateMenu()
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
