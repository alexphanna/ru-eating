//
//  DiningHall.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation
import SwiftSoup

class Place: Identifiable, Hashable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name && lhs.campus == rhs.campus && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(campus)
        hasher.combine(id)
    }
    
    var name: String
    var campus: String
    var hours: [(String, String)]
    var id: Int
    var hasTakeout: Bool
    
    var isOpen: Bool {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let openDate = dateFormatter.date(from: hours[Int(Calendar.current.component(.weekday, from: Date())) - 1].0)!
            let nowDate = dateFormatter.date(from: dateFormatter.string(from: Date()))!
            let closedDate = dateFormatter.date(from: hours[Int(Calendar.current.component(.weekday, from: Date())) - 1].1)!
            
            return nowDate.timeIntervalSince(openDate) >= 0 && nowDate.timeIntervalSince(closedDate) <= 0
        }
    }
    
    static let defaultHours = [("09:30", "20:00"), ("07:00", "21:00"), ("07:00", "21:00"), ("07:00", "21:00"), ("07:00", "21:00"), ("07:00", "21:00"), ("07:00", "21:00"), ("09:30", "20:00")]
    
    init(name: String, campus: String, id: Int, hasTakeout: Bool, hours: [(String, String)] = defaultHours) {
        self.name = name
        self.campus = campus
        self.hasTakeout = hasTakeout
        self.hours = hours
        self.id = id
    }
    
    func getURL(meal: String, date: Date) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + String(format: "%02d", id) + "&locationName=" + name.replacingOccurrences(of: " ", with: "+") + "&dtdate=" + dateFormatter.string(from: date) + "&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!
    }
    
    func fetchMenu(meal: String, date: Date, settings: Settings) async throws -> [Category] {
        var doc = try await fetchDoc(url: getURL(meal: meal, date: date))
        var elements = try! doc.select("div.menuBox h3, div.menuBox fieldset div.col-1 label, div.menuBox fieldset div.col-2 label, div.menuBox fieldset div.col-1 img").array()
        let breakfastCount = elements.count
        
        if meal == "Breakfast" {
            doc = try await fetchDoc(url: getURL(meal: "Lunch", date: date))
            elements.append(contentsOf: try! doc.select("div.menuBox h3, div.menuBox fieldset div.col-1 label, div.menuBox fieldset div.col-2 label, div.menuBox fieldset div.col-1 img").array())
        }
        
        var menu = [Category]();
        var lastCategory: Category? = nil
        var nonConstantIndex = 0
        var isBreakfast = false
        var i = 0
        while i < elements.count {
            let element = elements[i]
            
            if (element.tagName() == "h3") {
                var heading = String(try! element.text())
                // remove "-- " and " --" from headings and capitalize headings
                heading = String(heading[heading.index(after: heading.firstIndex(of: " ")!)..<heading.lastIndex(of: " ")!]).capitalized.replacingOccurrences(of: "/ ", with: " / ")
                if i >= breakfastCount {
                    if heading.contains("Breakfast") && !menu.contains(where: { $0.name == heading } ){
                        isBreakfast = true
                    }
                    else {
                        isBreakfast = false
                        i += 1
                        continue
                    }
                }
                lastCategory = Category(name: heading)
                if constantCategories.contains(heading.lowercased()) {
                    menu.append(lastCategory!)
                }
                else {
                    menu.insert(lastCategory!, at: nonConstantIndex)
                    nonConstantIndex += 1
                }
            }
            if (element.tagName() == "label") {
                if i >= breakfastCount && !isBreakfast {
                    i += 2 + (elements[i + 1].tagName() == "img" ? 1 : 0)
                    continue
                }
                // check if item is already on the menu
                var duplicate = false
                for category in menu {
                    for item in category.items {
                        if try! item.id == element.attr("for") {
                            duplicate = true;
                            break
                        }
                    }
                    if duplicate {
                        break
                    }
                }
                if (duplicate) {
                    i += 2 + (elements[i + 1].tagName() == "img" ? 1 : 0)
                    continue
                }
                
                // carbon footprint
                var carbonFootprint = 0
                if i + 2 < elements.count && elements[i + 1].tagName() == "img" {
                    switch try! elements[i + 1].attr("title") {
                    case "Low carbon foot print":
                        carbonFootprint = 1
                        break
                    case "Medium carbon foot print":
                        carbonFootprint = 2
                        break
                    case "High carbon foot print":
                        carbonFootprint = 3
                        break
                    default:
                        carbonFootprint = 0
                    }
                    i += 1
                }
                
                // servings
                let servings = try! elements[i + 1].text().split(separator: "\u{00A0}")
                var servingsNumber: Float = 0
                if !servings[0].contains("/") { // example: 1
                    servingsNumber = Float(Int(servings[0])!)
                }
                else if servings[0].contains("/") && servings[0].contains(" ") { // example: 1 1/2
                    let mixedFraction = String(servings[0]).split(separator: " ")
                    let fraction = String(mixedFraction[1]).split(separator: "/")
                    servingsNumber = (Float(fraction[0])! + Float(mixedFraction[0])! * Float(fraction[1])!) / Float(fraction[1])!
                }
                else if servings[0].contains("/") { // example: 1/2
                    let fraction = String(servings[0]).split(separator: "/")
                    servingsNumber = Float(fraction[0])! / Float(fraction[1])!
                }
                let servingsUnit: String = String(servings[1]).lowercased()
                
                // capitalize items
                lastCategory!.items.append(Item(name: try! element.attr("name").capitalized.replacingOccurrences(of: "  ", with: " "), id: try! element.attr("for"), servingsNumber: servingsNumber, servingsUnit: servingsUnit, carbonFootprint: carbonFootprint, isFavorite: settings.favoriteItemsIDs.contains(try! element.attr("for"))))
                
                i += 1
            }
            i += 1
        }
        
        return menu
    }
}