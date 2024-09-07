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
