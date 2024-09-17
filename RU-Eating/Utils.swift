//
//  Fetch.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import Foundation
import SwiftSoup

func fetchDoc(url: URL) async throws -> Document {
    let (data, _) = try await URLSession.shared.data(from: url)
    
    return try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
}

func hasNutritionalReport(doc: Document) -> Bool {
    return try! doc.select("h2:contains(Nutritional Information is not available for this recipe.)").array().count == 0
}

func formatFloat(n: Float) -> String {
    if n.remainder(dividingBy: 1) == 0 {
        return n.formatted(.number.precision(.fractionLength(0)))
    }
    return n.formatted(.number.precision(.fractionLength(1)))
}
