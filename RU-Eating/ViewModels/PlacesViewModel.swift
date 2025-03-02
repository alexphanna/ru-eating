//
//  PlacesViewModel.swift
//  RU Eating
//
//  Created by alex on 3/1/25.
//

import SwiftUI

@Observable class PlacesViewModel {
    var sortBy: String
    var groupByCampus: Bool
    
    init() {
        self.sortBy = "Name"
        self.groupByCampus = true
    }
}
