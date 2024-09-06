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
            DiningHallView()
                .tabItem {
                    Label("Dining Halls", systemImage: "fork.knife")
                }
            ItemsView()
                .tabItem {
                    Label("Items", systemImage: "carrot")
                }
        }
    }
}

#Preview {
    ContentView()
}
