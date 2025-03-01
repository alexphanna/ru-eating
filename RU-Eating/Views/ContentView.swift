//
//  ContentView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PlacesView()
                .tabItem {
                    Label("Places", systemImage: "fork.knife")
                }
            Text("Under Construction")
                .tabItem {
                    Label("Diary", systemImage: "book")
                }
            Text("Under Construction")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
