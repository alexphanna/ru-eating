//
//  Constants.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation

let diningHalls: [DiningHall] = [
    DiningHall(name: "Busch Dining Hall", campus: Campus.busch, id : 4, hasTakeout: true, hours: [("09:30", "20:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "21:00"), ("09:30", "20:00")]),
    DiningHall(name: "Livingston Dining Commons", campus: Campus.livingston, id : 3, hasTakeout: false),
    DiningHall(name: "Neilson Dining Hall", campus: Campus.cookDouglass, id : 5, hasTakeout: true),
    DiningHall(name: "The Atrium", campus: Campus.collegeAve, id : 13, hasTakeout: false, hours: [("09:30", "20:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "21:00"), ("09:30", "20:00")])
]

let places: [Place] = [
    // Busch
    Place(name: "Busch Dining Hall", campus: Campus.busch),
    Place(name: "Gerlanda's Pizza and Cafe", campus: Campus.busch),
    Place(name: "Harvest Juice Bar", campus: Campus.busch),
    Place(name: "Qdoba", campus: Campus.busch),
    Place(name: "Panera Bread", campus: Campus.busch),
    Place(name: "Szechwan Ichiban", campus: Campus.busch),
    
    // Livingston
    Place(name: "Henry's Diner", campus: Campus.livingston),
    Place(name: "Kilmer's Market", campus: Campus.livingston),
    Place(name: "Livingston Dining Commons", campus: Campus.livingston),
    Place(name: "Sbarro", campus: Campus.livingston),
    Place(name: "Starbucks", campus: Campus.livingston),
    
    // College Ave
    Place(name: "The Atrium", campus: Campus.collegeAve),
    Place(name: "Cafe West", campus: Campus.collegeAve),
    Place(name: "Panera Bread", campus: Campus.collegeAve),
    
    // Cook/Douglass
    Place(name: "Neilson Dining Hall", campus: Campus.cookDouglass),
    Place(name: "Cook Cafe", campus: Campus.cookDouglass),
    Place(name: "DC Bagels", campus: Campus.cookDouglass),
    Place(name: "Douglass Cafe", campus: Campus.cookDouglass),
    Place(name: "Harvest IFNH", campus: Campus.cookDouglass),
    Place(name: "Red Pine Pizza", campus: Campus.cookDouglass),
]

enum Campus: CaseIterable {
    case busch, livingston, collegeAve, cookDouglass
    
    var description: String {
        switch self {
        case .busch: return "Busch"
        case .livingston: return "Livingston"
        case .collegeAve: return "College Ave"
        case .cookDouglass: return "Cook/Douglass"
        }
    }
}

let meals = [
    "Breakfast",
    "Lunch",
    "Dinner"
]

let nutrients = [
    "Calories",
    "Fat",
    "Carbohydrates",
    "Saturated Fat",
    "Dietary Fiber",
    "Trans Fat",
    "Sugars",
    "Cholesterol",
    "Protein",
    "Sodium",
    "Iron",
    "Calcium"
]

let nutrientUnits = [
    "Calories" : "",
    "Fat" : "g",
    "Carbohydrates" : "g",
    "Saturated Fat" : "g",
    "Dietary Fiber" : "g",
    "Trans Fat" : "g",
    "Sugars" : "g",
    "Cholesterol" : "mg",
    "Protein" : "g",
    "Sodium" : "mg",
    "Iron" : "g",
    "Calcium" : "mg"
]

let constantCategories = [
    "breakfast misc",
    "salad bar",
    "breads",
    "fruits",
    "fruit",
    "deli bar entree",
    "yogurt bar",
    "salad dressing"
]

let perfectNutrients = [
    "Calories" : "Calories",
    "Total Fat" : "Fat",
    "Fat" : "Fat",
    "Tot. Carb." : "Carbohydrates",
    "Carbohydrates" : "Carbohydrates",
    "Sat. Fat" : "Saturated Fat",
    "Saturated Fat" : "Saturated Fat",
    "Dietary Fiber" : "Dietary Fiber",
    "Trans Fat" : "Trans Fat",
    "Trans Fatty Acid" : "Trans Fat",
    "Sugars" : "Sugars",
    "Total Sugars" : "Sugars",
    "Cholesterol" : "Cholesterol",
    "Protein" : "Protein",
    "Sodium" : "Sodium",
    "Calcium" : "Calcium",
    "Iron" : "Iron"
]

let dailyValues = [
    "Calories" : 2000,
    "Fat" : 78,
    "Carbohydrates" : 275,
    "Saturated Fat" : 20,
    "Dietary Fiber" : 28,
    "Trans Fat" : 1,
    // "Sugars" : 50, Added Sugar
    "Cholesterol" : 300,
    "Protein" : 50,
    "Sodium" : 2300,
    "Iron" : 18,
    "Calcium" : 1300
]

let unimportantWords = ["and", "for", "on", "to", "oz", "of", "the"]
