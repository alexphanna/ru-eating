//
//  PlacesViewModel.swift
//  RU Eating
//
//  Created by alex on 3/1/25.
//

import SwiftUI

@Observable class PlacesViewModel {
    var sortBy: String
    var filter: String
    var groupByCampus: Bool
    
    var filteredPlaces: [Place] {
        switch filter {
        case "Favorites":
            return places.filter { $0.isFavorite }
        case "Accepts Meal Swipes":
            return places.filter { $0.acceptsMealSwipes }
        default:
            return places
        }
    }
    
    init() {
        self.sortBy = "Name"
        self.filter = "All Places"
        self.groupByCampus = true
    }
}
