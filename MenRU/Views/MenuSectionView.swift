//
//  MenuSectionView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct MenuSectionView : View {
    @State var category: Category
    @State var sectionExpanded: Bool = true
    
    var body : some View {
        Section(
            isExpanded: $sectionExpanded,
            content: {
                ForEach(category.items) { item in
                    ItemView(item: item)
                }
            },
            header: { Text(category.name) })
    }
}
