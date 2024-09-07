//
//  SettingsView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct SettingsView : View {
    @Environment(\.dismiss) var dismiss
    @Bindable var settings: Settings
    
    var body : some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $settings.allergic) {
                        Text("Check Ingredients")
                    }
                    if (settings.allergic) {
                        NavigationLink("Allergies") {
                            AllergiesView(settings: settings)
                        }
                    }
                } header: {
                    Text("Allergies")
                } footer: {
                    Text("Filter through item ingredients and display \(Image(systemName: "exclamationmark.triangle.fill")) next to items with potential allergies.")
                }
                Section("Support") {
                    Link(destination: URL(string: "https://www.github.com/alexphanna/menru")!, label: {
                        Label("Star on GitHub", systemImage: "star")
                    })
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: { dismiss() })
                }
            }
        }
    }
}
