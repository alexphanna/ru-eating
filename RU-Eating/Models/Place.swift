//
//  DiningHall.swift
//  MenRU
//
//  Created by alex on 9/9/24.
//

import Foundation
import SwiftSoup
import SwiftUI

protocol Place: Identifiable, Hashable {
    var name: String { get }
    var campus: Campus { get }
    var acceptsMealSwipes: Bool { get }
    var isFavorite: Bool { get set }
    
    func fetchMenu(meal: String, date: Date) async throws -> [Category]
    
    func hash(into hasher: inout Hasher)
}
