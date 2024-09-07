//
//  Settings.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftData

@Model
class Settings {
    var allergic: Bool
    var allergies: [String]
    
    init(allergic: Bool = false, allergies: [String] = []) {
        self.allergic = allergic
        self.allergies = allergies
    }
}
