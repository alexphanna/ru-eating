//
//  DiningHall.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation

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
    
    init(name: String, campus: String, id: Int, hours: [(String, String)] = defaultHours) {
        self.name = name
        self.campus = campus
        self.hours = hours
        self.id = id
    }
    
    func getURL(meal: String) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/pickmenu.aspx?locationNum=" + String(format: "%02d", id) + "&locationName=" + name.replacingOccurrences(of: " ", with: "+") + "&dtdate=" + "09/14/2024"/*dateFormatter.string(from: Date.now)*/ + "&activeMeal=" + meal + "&sName=Rutgers+University+Dining")!
    }
    
    func fetchMenu(meal: String, settings: Settings) async throws -> [Category] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var doc = try await fetchDoc(url: getURL(meal: meal))
        var elements = try! doc.select("div.menuBox h3, div.menuBox fieldset div.col-1 label, div.menuBox fieldset div.col-2 label").array()
        let breakfastCount = elements.count
        
        if meal == "Breakfast" {
            doc = try await fetchDoc(url: getURL(meal: "Lunch"))
            elements.append(contentsOf: try! doc.select("div.menuBox h3, div.menuBox fieldset div.col-1 label, div.menuBox fieldset div.col-2 label").array())
        }
        
        var menu = [Category]();
        var isBreakfast = false
        for i in 0..<elements.count {
            let element = elements[i]
            
            if (element.tagName() == "h3") {
                var heading = String(try! element.text())
                // remove "-- " and " --" from headings and capitalize headings
                heading = String(heading[heading.index(after: heading.firstIndex(of: " ")!)..<heading.lastIndex(of: " ")!]).capitalized
                if i >= breakfastCount {
                    if heading.contains("Breakfast") && !menu.contains(where: { $0.name == heading } ){
                        print(heading)
                        isBreakfast = true
                    }
                    else {
                        isBreakfast = false
                        continue
                    }
                }
                menu.append(Category(name: heading))
            }
            if (element.tagName() == "label") {
                if i >= breakfastCount && !isBreakfast {
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
                    continue
                }
                
                let servingsNumber = try? Int(elements[i + 1].attr("aria-label").first!.description) ?? 1
                let servingsUnit = try? elements[i + 1].attr("aria-label").replacingOccurrences(of: String(servingsNumber!), with: "").lowercased()
                
                // capitalize items
                menu[menu.count - 1].items.append(Item(name: try! element.attr("name").capitalized.replacingOccurrences(of: "  ", with: " "), id: try! element.attr("for"), servingsNumber: servingsNumber!, servingsUnit: servingsUnit!, isFavorite: settings.favoriteItemsIDs.contains(try! element.attr("for"))))
            }
        }
        
        return menu
    }
}
