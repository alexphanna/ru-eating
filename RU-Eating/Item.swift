//
//  Item.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import Foundation

@Observable class Item : Hashable, Identifiable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
        hasher.combine(portion)
    }
    
    var name : String
    var id : String
    var ingredients: String
    var restricted: Bool
    var servingsNumber: Int
    private var servingsUnit: String
    var servingSize: String {
        get {
            return "\(servingsNumber) \(servingsUnit)"
        }
    }
    var portion: Int // number of servings
    var isFavorite: Bool
    
    func incrementPortion() {
        portion += 1
    }
    
    func decrementPoriton() {
        portion -= 1
        if portion < 0 { portion = 0 }
    }
    
    init(name: String, id: String, servingsNumber: Int, servingsUnit: String, portion: Int = 1, isFavorite: Bool = false) {
        self.name = name
        self.id = id
        self.servingsNumber = servingsNumber
        self.servingsUnit = servingsUnit
        self.portion = portion
        self.isFavorite = isFavorite
        self.ingredients = ""
        self.restricted = false
    }
    
    func fetchIngredients() async throws -> String {
        let doc = try await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + id + "*1")!)
        if !hasNutritionalReport(doc: doc) {
            return ""
        }
        let elements = try! doc.select("div.col-md-12 > p").array()
        
        let text = try! elements[0].text()
        let textArray = text.split(separator: "\u{00A0}")
        
        return String(textArray[textArray.count - 1]).capitalized;
    }
}
