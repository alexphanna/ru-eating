//
//  DiningHallView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct MenusView : View {
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
    @State private var isShowingSheet = false
    @Environment(Settings.self) private var settings
    
    var body : some View {
        NavigationStack {
            List {
                ForEach(Array(places.keys).sorted(), id: \.self) { place in
                    NavigationLink {
                        MenuView(place: place)
                    } label: {
                        VStack (alignment: HorizontalAlignment.leading) {
                            Text(place)
                            Text(campuses[place]!).font(.footnote).italic().foregroundStyle(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Menus")
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
}
