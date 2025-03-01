//
//  DiningHall.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation
import SwiftSoup
import SwiftUI

class Place: Identifiable, Hashable {
    var name: String
    var id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(id)
    }
}
