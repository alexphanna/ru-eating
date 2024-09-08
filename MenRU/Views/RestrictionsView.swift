//
//  AllergenView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct RestrictionsView : View {
    @Bindable var settings: Settings
    @State private var isSheetShowing: Bool = false
    
    var body: some View {
        List {
            ForEach(settings.restrictions, id: \.self) { restriction in
                Text(restriction)
            }
            .onDelete(perform: { settings.restrictions.remove(atOffsets: $0) })
        }
        .navigationTitle("Dietary Restrictions")
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
            AddRestrictionView(settings: settings)
        }
    }
}
