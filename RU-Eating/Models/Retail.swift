//
//  RetailMenu.swift
//  RU Eating
//
//  Created by alex on 3/2/25.
//

import SwiftUI

@Observable class Retail: Place, Hashable {
    var name: String
    var id: String
    var campus: Campus
    var acceptsMealSwipes: Bool
    var isFavorite: Bool
    
    init(name: String, id: String, campus: Campus, acceptsMealSwipes: Bool = false) {
        self.name = name
        self.id = id
        self.campus = campus
        self.acceptsMealSwipes = acceptsMealSwipes
        self.isFavorite = false
    }
    
    func fetchMenu(meal: String = "", date: Date = .now) async throws -> [Category] {
        let doc = try await fetchDoc(url: URL(string: "https://food.rutgers.edu/places-eat/retail-dining-menus")!)
        let elements = try! doc.select("h2#" + id + ".menu-title + div.menu-well *").array()
        
        var menu = [Category]()
        var lastCategory: Category? = nil
        var i = 0
        while i < elements.count {
            let element = elements[i]
            
            if (element.tagName() == "h3") {
                lastCategory = Category(name: try! element.text())
                menu.append(lastCategory!)
            }
            else if (element.tagName() == "li") {
                let itemName = String(try! element.text()[..<((try! element.text()).firstIndex(of: "—") ?? (try! element.text()).endIndex)])
                if lastCategory == nil {
                    lastCategory = Category(name: "All")
                    menu.append(lastCategory!)
                }
                lastCategory!.items.append(Item(name: itemName, id: itemName))
            }
            i += 1
        }
        
        return menu
    }
    
    static func == (lhs: Retail, rhs: Retail) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
