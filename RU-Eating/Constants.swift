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
    "Sodium" : "mg",
    "Iron" : "g",
    "Calcium" : "mg"
]

let constantCategories = [
    "breakfast misc",
    "salad bar",
    "breads",
    "fruits",
    "deli bar entree"
]

let amountNutrients = [
    "Calories" : "Calories",
    "Total Fat" : "Fat",
    "Tot. Carb." : "Carbohydrates",
    "Sat. Fat" : "Saturated Fat",
    "Dietary Fiber" : "Dietary Fiber",
    "Trans Fat" : "Trans Fat",
    "Sugars" : "Sugars",
    "Cholesterol" : "Cholesterol",
    "Protein" : "Protein",
    "Sodium" : "Sodium"
]

let dailyValueNutrients = [
    "Calories" : "Calories",
    "Protein" : "Protein",
    "Fat" : "Fat",
    "Carbohydrates" : "Carbohydrates",
    "Cholesterol" : "Cholesterol",
    "Total Sugars" : "Sugars",
    "Dietary Fiber" : "Dietary Fiber",
    "Sodium" : "Sodium",
    "Saturated Fat" : "Saturated Fat",
    "Calcium" : "Calcium",
    "Trans Fatty Acid" : "Trans Fat",
    "Mono Fat" : "Monounsaturated Fat",
    "Poly Fat" : "Polyunsaturated Fat",
    "Iron" : "Iron"
]
