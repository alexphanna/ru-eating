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
    @Environment(\.requestReview) private var requestReview
    
    @AppStorage("numberOfUses") var numberOfUses: Int = 0
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    numberOfUses += 1
                    if numberOfUses % 10 == 0 {
                        requestReview()
                    }
                }
        }
    }
}
