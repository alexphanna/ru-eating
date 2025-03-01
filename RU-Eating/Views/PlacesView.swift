//
//  DiningHallView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct PlacesView : View {
    @State private var isSheetShowing = false
    
    var body : some View {
        NavigationStack {
            List {
                if !diningHalls.filter({ $0.isOpen }).isEmpty {
                    Section("Open") {
                        ForEach(diningHalls.filter { $0.isOpen }, id: \.self) { place in
                            MenuView(viewModel: MenuViewModel(place: place))
                        }
                    }
                }
                if !diningHalls.filter({ !$0.isOpen }).isEmpty {
                    Section("Closed") {
                        ForEach(diningHalls.filter { !$0.isOpen }, id: \.self) { place in
                            MenuView(viewModel: MenuViewModel(place: place))
                        }
                    }
                }
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isSheetShowing = true }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .sheet(isPresented: $isSheetShowing, content: {
                SettingsView()
            })
        }
    }
}
