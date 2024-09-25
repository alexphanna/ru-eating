//
//  MenuSectionView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct CategoryView : View {
    @Bindable var viewModel: CategoryViewModel
    @Environment(Settings.self) private var settings
    
    var body : some View {
        Section(
            isExpanded: $viewModel.isExpanded,
            content: {
                ForEach(viewModel.category.items.sorted(by: { $0.name < $1.name })) { item in
                    ItemView(viewModel: ItemViewModel(item: item, settings: settings))
                }
            },
            header: { Text(viewModel.category.name) })
    }
}
