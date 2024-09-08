//
//  AddAllergyView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct AddRestrictionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var ingredient: String = ""
    @Bindable var settings: Settings
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent {
                        TextField("Peanut", text: $ingredient)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Ingredient")
                    }
                } footer: {
                    Text("When adding dietary restrictions, make sure that you write it singular to increase accuracy. For example, add \"Peanut\" not \"Peanuts\".")
                }
            }
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        settings.restrictions.append(ingredient.trimmingCharacters(in: .whitespaces))
                        dismiss()
                    }
                    .disabled(ingredient.trimmingCharacters(in: .whitespaces).isEmpty)
                    .disabled(settings.restrictions.contains(ingredient.trimmingCharacters(in: .whitespaces)))
                }
            }
        }
        .presentationDetents([.medium])
    }
}
