//
//  DiarySection.swift
//  Nutrition
//
//  Created by alex on 10/11/24.
//

import SwiftUI

struct DiarySection: View {
    @State var diary: Diary
    @State var meal: Meal
    @State var isExpanded: Bool = true
    
    @Binding var selectedMeal: Meal?
    @Binding var sheet: Sheet
    
    var body: some View {
        Section(
            isExpanded: $isExpanded,
            content: {
                Menu {
                    Button("Scan Barcode", systemImage: "barcode.viewfinder") {
                        sheet = .barcode
                        selectedMeal = meal
                    }
                    Button("Scan Nutrition Facts", systemImage: "text.viewfinder", action: {})
                        .disabled(true)
                    Button("Enter Manually", systemImage: "character.cursor.ibeam") {
                        sheet = .manual
                        selectedMeal = meal
                    }
                } label: {
                    HStack {
                        Label("Add Item", systemImage: "plus")
                        Spacer()
                    }
                }
            },
            header: {
                Text(meal.name)
            })
    }
}
