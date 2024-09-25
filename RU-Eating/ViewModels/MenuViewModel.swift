//
//  CategoryViewModel.swift
//  RU Eating
//
//  Created by alex on 9/24/24.
//

import Foundation

@Observable class MenuViewModel {
    // core
    private(set) var place: Place
    var meal: String
    var date: Date
    
    // settings and filtering
    private var settings: Settings
    var isGrouped: Bool
    var searchText: String
    var filter: String
    
    private(set) var rawMenu: [Category]
    var menu: [Category] {
        var menu: [Category] = [Category]()
        
        for category in rawMenu {
            let filteredCategory: Category = Category(name: category.name)
            
            switch filter {
            case "Favorites":
                filteredCategory.items.append(contentsOf: category.items.filter { $0.isFavorite })
                break
            case "Low Carbon Footprint":
                filteredCategory.items.append(contentsOf: category.items.filter { $0.carbonFootprint == 1 })
                break
            default:
                filteredCategory.items.append(contentsOf: category.items)
                break
            }
            
            if !searchText.isEmpty {
                let searchedCategory: Category = Category(name: category.name)
                
                for item in filteredCategory.items {
                    if item.name.lowercased().contains(searchText.lowercased()) {
                        searchedCategory.items.append(item)
                    }
                }
                
                if !searchedCategory.items.isEmpty {
                    menu.append(searchedCategory)
                }
            }
            else if !filteredCategory.items.isEmpty {
                menu.append(filteredCategory)
            }
        }
        
        return menu
    }
    
    var items: Category {
        let category: Category = Category(name: "All")
        
        for _category in menu {
            category.items.append(contentsOf: _category.items)
        }
        
        category.items = category.items.sorted(by: { $0.name < $1.name })
        
        return category
    }
    
    // improve this
    private var dayName: String? {
        switch Calendar.current.dateComponents([.year, .month, .day], from: date) {
        case Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!):
            return "Yesterday"
        case Calendar.current.dateComponents([.year, .month, .day], from: Date.now):
            return "Today"
        case Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!):
            return "Tomorrow"
        default:
            return nil
        }
    }
    
    var dateText: String {
        return "\(dayName ?? date.formatted(Date.FormatStyle().weekday(.wide))), \(date.formatted(Date.FormatStyle().month(.wide))) \(date.formatted(Date.FormatStyle().day()))"
    }
    
    init(place: Place, settings: Settings) {
        self.place = place
        self.meal = "Breakfast"
        self.date = Date.now
        
        self.settings = settings
        self.isGrouped = true
        self.searchText = ""
        self.filter = "All Items"
        
        self.rawMenu = [Category]()
    }
    
    func updateMenu() async {
        rawMenu = [Category]()
        do {
            rawMenu = try await place.fetchMenu(meal: meal == "Takeout" ? "Knight+Room" : meal, date: date, settings: settings)
        } catch {
            print(error)
        }
    }
    
    func decrementDate() {
        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!;
        Task { await updateMenu() }
    }
    
    func incrementDate() {
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!;
        Task { await updateMenu() }
    }
}