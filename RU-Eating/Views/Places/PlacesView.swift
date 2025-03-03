//
//  DiningHallView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct PlacesView : View {
    @State var viewModel: PlacesViewModel
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.groupByCampus {
                    ForEach(Campus.allCases, id: \.self) { campus in
                        Section(campus.description) {
                            ForEach(viewModel.filteredPlaces.filter { $0.campus == campus }, id: \.name) { place in
                                PlaceView(place: place)
                            }
                        }
                    }
                }
                else {
                    Section("Name") {
                        ForEach(viewModel.filteredPlaces.sorted{ $0.name < $1.name }, id: \.name) { place in
                            PlaceView(place: place)
                        }
                    }
                }
            }
            .navigationTitle("Places to Eat")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Toggle("Group by Campus", systemImage: "building.columns", isOn: $viewModel.groupByCampus)
                            Picker(selection: $viewModel.sortBy) {
                                Label("Name", systemImage: "textformat.alt").tag("Name")
                                Label("Campus", systemImage: "building.columns").tag("Campus")
                            } label: {
                                Label("Sort By" , systemImage: "arrow.up.arrow.down")
                                Text(viewModel.sortBy)
                            }
                            .pickerStyle(.menu)
                            Picker(selection: $viewModel.filter ) {
                                Section {
                                    Label("All Places", systemImage: "fork.knife").tag("All Places")
                                }
                                Section {
                                    Label("Favorites", systemImage: "star").tag("Favorites")
                                    Label("Accepts Meal Swipes", systemImage: "dollarsign").tag("Accepts Meal Swipes")
                                }
                            } label: {
                                Label("Filter", systemImage: viewModel.filter == "All Places" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                                Text(viewModel.filter)
                            }
                            .pickerStyle(.menu)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}
