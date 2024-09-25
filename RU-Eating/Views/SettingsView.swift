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
            VStack {
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
                        Text("Filter through item's ingredients and display a \(Image(systemName: "exclamationmark.triangle.fill")) next to items or hide items that may contain dietary restrictions.")
                    }
                    Section {
                        Toggle(isOn: $settings.carbonFootprints) {
                            Text("Carbon Footprints")
                        }
                    } header: {
                        Text("Extra Information")
                    } footer: {
                        Text("Display a \(Image(systemName: "leaf.fill")) next to items with the color corresponding to the carbon footprint: green = low, orange = medium, red = high. Not all items have carbon footprint information.")
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
                        Button {
                            openURL(URL(string: "https://www.instagram.com/avg4cyl")!)
                        } label: {
                            HStack {
                                Text("Frankie Gonzales")
                                    .foregroundStyle(Color(uiColor: .label))
                                Spacer()
                                Text("Name")
                                    .foregroundStyle(.gray)
                                NavigationLink(destination: EmptyView(), label: { EmptyView() })
                                    .fixedSize()
                                    .foregroundStyle(Color(uiColor: .label))
                            }
                        }
                    }
                    Section {
                        Link(destination: URL(string: "mailto:alex.hanna@rutgers.edu")!, label: {
                            Label("Email Developer", systemImage: "envelope")
                                .foregroundStyle(.foreground)
                        })
                        Link(destination: URL(string: "https://www.github.com/alexphanna/RU-Eating/issues/new")!, label: {
                            Label("Create an Issue", systemImage: "smallcircle.fill.circle")
                                .foregroundStyle(.foreground)
                        })
                        Link(destination: URL(string: "https://apps.apple.com/us/app/ru-eating/id6692608792?action=write-review")!, label: {
                            Label("Write a Review", systemImage: "message")
                                .foregroundStyle(.foreground)
                        })
                    } header: {
                        Text("Feedback")
                    } footer: {
                        Text("Version: 1.0.2")
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
}
