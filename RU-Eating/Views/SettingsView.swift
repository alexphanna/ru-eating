//
//  SettingsView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct SettingsView : View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @Bindable var settings: Settings
    
    var body : some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $settings.filterIngredients) {
                        Text("Filter Ingredients")
                    }
                    if (settings.filterIngredients) {
                        Toggle(isOn: $settings.hideRestricted) {
                            Text("Hide Restricted Items")
                        }
                        NavigationLink("Dietary Restrictions") {
                            RestrictionsView(settings: settings)
                        }
                    }
                } header: {
                    Text("Dietary Restrictions")
                } footer: {
                    Text("Filter through item ingredients and display \(Image(systemName: "exclamationmark.triangle.fill")) next to items or hide items with potential dietary restrictions.")
                }
                Section("Credits") { // Inspired by delta
                    Button {
                        openURL(URL(string: "https://www.github.com/alexphanna")!)
                    } label: {
                        HStack {
                            Text("Alex Hanna")
                                .foregroundStyle(Color(uiColor: .label))
                            Spacer()
                            Text("Developer")
                                .foregroundStyle(.gray)
                            NavigationLink(destination: EmptyView(), label: { EmptyView() })
                                .fixedSize()
                                .foregroundStyle(Color(uiColor: .label))
                        }
                    }
                }
                Section("Support") {
                    Link(destination: URL(string: "https://www.github.com/alexphanna/RU-Eating")!, label: {
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
