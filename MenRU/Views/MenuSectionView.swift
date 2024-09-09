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
    @Environment(Settings.self) private var settings
    
    var body : some View {
        if (settings.hideUnfavorited && !category.items.allSatisfy({ $0.isFavorite == false })) || !settings.hideUnfavorited {
            Section(
                isExpanded: $menuSectionSettings.sectionExpanded,
                content: {
                    ForEach(category.items.sorted(by: { $0.name < $1.name })) { item in
                        if (settings.hideUnfavorited && item.isFavorite) || !settings.hideUnfavorited {
                            ItemView(item: item)
                        }
                    }
                },
                header: { Text(category.name) })
        }
    }
}

// persists collapsed sections when going in and out of view
@Observable class MenuSectionSettings {
    var sectionExpanded: Bool = true
}
