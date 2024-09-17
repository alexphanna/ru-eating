//
//  Constants.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation

let places: [Place] = [
    Place(name: "Busch Dining Hall", campus: "Dine In / Takeout", id : 4, hasTakeout: true),
    Place(name: "Livingston Dining Commons", campus: "Dine In", id : 3, hasTakeout: false),
    Place(name: "Neilson Dining Hall", campus: "Dine In / Takeout", id : 5, hasTakeout: true),
    Place(name: "The Atrium", campus: "Dine In", id : 13, hasTakeout: false, hours: [("09:30", "20:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "23:00"), ("07:00", "21:00"), ("09:30", "20:00")])
]

let meals = [
    "Breakfast",
    "Lunch",
    "Dinner"
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
    "Sodium" : "mg"
]
