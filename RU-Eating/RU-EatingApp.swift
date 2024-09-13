//
//  MenRUApp.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftData

@main
struct MenRUApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: Settings.self)
        }
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.requestReview) private var requestReview
    @Query private var settings: [Settings]
    
    var body: some View {
        ContentView()
            .onAppear {
                if settings.isEmpty {
                    context.insert(Settings())
                }
                (settings.first ?? Settings()).numberOfUses += 1
                if (settings.first ?? Settings()).numberOfUses % 10 == 0 {
                    requestReview()
                }
            }.environment(settings.first ?? Settings())
    }
}
