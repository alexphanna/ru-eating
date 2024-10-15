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
    var sortBy: String
    var groupByCategory: Bool
    var sortOrder: String
    var nutrient: String
    var filter: String
    
    private(set) var rawMenu: [Category]
    private(set) var fetched: Bool
    
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
            
            if !filteredCategory.items.isEmpty {
                menu.append(filteredCategory)
            }
        }
        
        return menu
    }
    
    var isEditing: Bool = false
    
    var items: Category {
        let category: Category = Category(name: "All")
        
        for _category in menu {
            category.items.append(contentsOf: _category.items)
        }
        
        return category
    }
    
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
    
    var randomItem: Item?
    
    var selectedItemsNames: [String] {
        return items.items.filter { $0.isSelected }.map { $0.name }
    }
    
    init(place: Place, settings: Settings) {
        self.place = place
        switch Calendar.current.component(.hour, from: Date.now) {
        case ..<11:
            self.meal = "Breakfast"
        case ..<17:
            self.meal = "Lunch"
        default:
            self.meal = "Dinner"
        }
        self.date = Date.now
        
        self.settings = settings
        self.isGrouped = false
        self.sortBy = "None"
        self.sortOrder = "Ascending"
        self.groupByCategory = true
        self.nutrient = "Calories"
        self.filter = "All Items"
        
        self.rawMenu = [Category]()
        self.fetched = false
    }
    
    func updateMenu() async {
        fetched = false
        rawMenu = [Category]()
        sortBy = "None"
        filter = "All Items"
        do {
            rawMenu = try await place.fetchMenu(meal: meal == "Takeout" ? "Knight+Room" : meal, date: date, settings: settings)
            if !items.items.isEmpty {
                randomItem = items.items.randomElement()!
            }
            for category in rawMenu {
                for item in category.items {
                    await item.fetchData(settings: settings)
                }
            }
        } catch {
            // do nothing
        }
        fetched = true
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
