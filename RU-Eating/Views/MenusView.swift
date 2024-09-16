//
//  DiningHallView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup
import StoreKit

struct MenusView : View {
    @State private var isSheetShowing = false
    @Environment(Settings.self) private var settings
    
    var body : some View {
        NavigationStack {
            List {
                let openPlaces = getOpenPlaces()
                if openPlaces.count > 0 {
                    Section("Open") {
                        ForEach(openPlaces, id: \.self) { place in
                            MenuView(place: place)
                        }
                    }
                }
                let closedPlaces = getClosedPlaces()
                if closedPlaces.count > 0 {
                    Section("Closed") {
                        ForEach(closedPlaces, id: \.self) { place in
                            MenuView(place: place)
                        }
                    }
                }
            }
            .navigationTitle("Menus")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isSheetShowing = true }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .sheet(isPresented: $isSheetShowing, content: {
                SettingsView(settings: settings)
            })
        }
    }
    
    func getOpenPlaces() -> [Place]  {
        var openPlaces = [Place]()
        for place in places {
            if place.isOpen {
                openPlaces.append(place)
            }
        }
        return openPlaces
    }
    
    func getClosedPlaces() -> [Place] {
        var closedPlaces = [Place]()
        for place in places {
            if !place.isOpen {
                closedPlaces.append(place)
            }
        }
        return closedPlaces
    }
}
