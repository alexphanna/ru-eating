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
            PlacesView(viewModel: PlacesViewModel())
                .tabItem {
                    Label("Places", systemImage: "fork.knife")
                }
            DiaryView()
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
