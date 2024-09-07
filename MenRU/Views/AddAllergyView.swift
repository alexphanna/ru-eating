//
//  AddAllergyView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct AddAllergyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var ingredient: String = ""
    @Bindable var settings: Settings
    
    var body: some View {
        NavigationStack {
            Form {
                LabeledContent {
                    TextField("Peanut", text: $ingredient)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Ingredient")
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
                        settings.allergies.append(ingredient)
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
