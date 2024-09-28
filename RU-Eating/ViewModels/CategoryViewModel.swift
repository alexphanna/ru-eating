//
//  CategoryViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation
import OrderedCollections

@Observable class CategoryViewModel {
    var category: Category
    var searchText: String
    var isExpanded: Bool
    
    init(category: Category, searchText: String) {
        self.category = category
        self.searchText = searchText;
        self.isExpanded = true
    }
}
