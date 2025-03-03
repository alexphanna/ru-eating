//
//  SimpleMenuView.swift
//  RU Eating
//
//  Created by alex on 3/2/25.
//

import SwiftUI

struct SimpleMenuView: View {
    @State var place: Retail
    @State var menu: [Category] = [Category]()
    
    var body: some View {
        List {
            ForEach(menu) { category in
                CategoryView(viewModel: CategoryViewModel(category: category, sortBy: "Name", sortOrder: "Ascending", isEditing: false))
            }
        }
        .task {
            menu = try! await place.fetchMenu()
        }
    }
}
