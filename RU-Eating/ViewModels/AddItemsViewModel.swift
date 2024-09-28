//
//  AddItemsViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation

@Observable class AddItemsViewModel {
    var meal: Category
    
    private var settings: Settings
    var searchText: String
    var searchScope: String
    private(set) var fetched: Bool
    
    private(set) var rawItems: [Item]
    var items: [Item] {
        if (searchText.isEmpty) {
            return rawItems
        }
        else {
            return rawItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    init(meal: Category, settings: Settings) {
        self.meal = meal
        
        self.searchText = ""
        self.searchScope = settings.defaultDiningHall
        self.settings = settings
        self.fetched = false
        
        self.rawItems = [Item]()
    }
    
    func updateItems() async {
        fetched = false
        rawItems = [Item]()
        for place in places {
            if !place.name.contains(searchScope) { continue }
            for meal in meals {
                do {
                    let menu = try await place.fetchMenu(meal: meal, date: Date.now, settings: settings)
                    
                    for category in menu {
                        for item in category.items {
                            if !rawItems.contains(item) {
                                rawItems.append(item)
                            }
                        }
                    }
                } catch {
                    // do nothing
                }
            }
            break
        }
        fetched = true
    }
    
    func getHighlightedName(item: Item) -> AttributedString {
        var name = AttributedString(item.name)
        let lowercasedName = AttributedString(item.name.lowercased())
        
        for range in lowercasedName.characters.ranges(of: searchText.lowercased()) {
            name[range].foregroundColor = .accent
        }
        
        return name
    }
}
