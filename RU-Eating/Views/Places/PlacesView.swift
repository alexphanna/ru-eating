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
                            ForEach(places.filter { $0.campus == campus }) { place in
                                PlaceView(place: place)
                            }
                        }
                    }
                }
                else {
                    Section("Name") {
                        ForEach(places.sorted{ $0.name < $1.name }) { place in
                            PlaceView(place: place)
                        }
                    }
                }
            }
            .navigationTitle("Places")
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
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}
