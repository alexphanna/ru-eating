//
//  DiningHall.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation
import SwiftSoup
import SwiftUI

@Observable class Place: Identifiable, Hashable {
    var name: String
    var campus: Campus
    var isFavorite: Bool
    
    init(name: String, campus: Campus) {
        self.name = name
        self.campus = campus
        self.isFavorite = false
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
    }
}
