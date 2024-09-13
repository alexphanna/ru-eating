//
//  MenuSectionView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct CategoryView : View {
    @Bindable var category: Category
    @Bindable var menuSectionSettings: MenuSectionSettings = MenuSectionSettings()
    @Binding var searchText: String
    @Environment(Settings.self) private var settings
    
    var body : some View {
        Section(
            isExpanded: $menuSectionSettings.sectionExpanded,
            content: {
                ForEach(category.items.sorted(by: { $0.name < $1.name })) { item in
                    ItemView(item: item, searchText: $searchText)
                }
            },
            header: { Text(category.name) })
    }
}

// persists collapsed sections when going in and out of view
@Observable class MenuSectionSettings {
    var sectionExpanded: Bool = true
}
