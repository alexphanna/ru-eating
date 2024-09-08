//
//  MenuSectionView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct MenuSectionView : View {
    @State var category: Category
    @Bindable var menuSectionSettings: MenuSectionSettings = MenuSectionSettings()
    
    var body : some View {
        Section(
            isExpanded: $menuSectionSettings.sectionExpanded,
            content: {
                ForEach(category.items) { item in
                    ItemView(item: item)
                }
            },
            header: { Text(category.name) })
    }
}

// persists collapsed sections when going in and out of view
@Observable class MenuSectionSettings {
    var sectionExpanded: Bool = true
}
