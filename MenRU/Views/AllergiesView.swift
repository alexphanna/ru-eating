//
//  AllergenView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct AllergiesView : View {
    @Bindable var settings: Settings
    @State private var isSheetShowing: Bool = false
    
    var body: some View {
        List {
            Section {
                ForEach(settings.allergies, id: \.self) { allergy in
                    Text(allergy)
                }
                .onDelete(perform: delete)
            } footer: {
                Text("When adding allergies, make sure that you write it singular to increase accuracy. For example, add \"Peanut\" not \"Peanuts\".")
            }
        }
        .navigationTitle("Allergies")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isSheetShowing = true }) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $isSheetShowing) {
            AddAllergyView(settings: settings)
        }
    }
    
    func delete(at offsets: IndexSet) {
        settings.allergies.remove(atOffsets: offsets)
    }
}
