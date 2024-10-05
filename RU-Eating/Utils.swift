//
//  Fetch.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import Foundation
import SwiftSoup
import OrderedCollections

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

func perfectName(name: String) -> String {
    let replacements = [
        "#5" : "",
        "Ff" : "",
        "Ww" : "Whole Wheat",
        "W/" : "With",
        "Wit" : "With",
        "&" : "and",
        
        // plural -> singular
        "burgers" : "burger",
        "dogs" : "dog"
    ]
    
    var nameArray = name.capitalized.replacingOccurrences(of: "  ", with: " ").split(separator: " ")
    
    for i in 0..<nameArray.count {
        if nameArray[i].hasSuffix("Oz") {
            nameArray[i] = nameArray[i].replacing("Oz", with: " oz")
        }
        else if replacements[String(nameArray[i])] != nil {
            nameArray[i] = String.SubSequence(replacements[String(nameArray[i])]!)
        }
    }
    
    return titleCase(title: nameArray.joined(separator: " "))
}

func titleCase(title: String) -> String {
    let blacklist = ["and", "for", "on", "to", "oz", "of", "the"]
    
    var newTitle = ""
    let titleArray = title.split(separator: " ")
    
    for i in 0..<titleArray.count {
        if i == titleArray.count - 1 && !blacklist.contains(String(titleArray[i]).lowercased()) {
            newTitle += "\(titleArray[i].capitalized)"
        }
        else if i == 0 || !blacklist.contains(String(titleArray[i]).lowercased()) {
            newTitle += "\(String(titleArray[i]).capitalized) "
        }
        else {
            newTitle += "\(String(titleArray[i]).lowercased()) "
        }
    }
    
    return newTitle
}

func multiplyDictionary(dict: OrderedDictionary<String, Float?>, multiplier: Float) -> OrderedDictionary<String, Float?> {
    var newDict = OrderedDictionary<String, Float?>()
    for key in Array(dict.keys) {
        newDict[key] = dict[key]! == nil ? nil : dict[key]!! * multiplier
    }
    return newDict
}

func extractFirstSentence(text: String) -> String {
    let textArray = Array(text)
    var newText = ""
    var ignore: Bool = false
    for char in textArray {
        if char == "(" {
            newText.removeLast()
            ignore = true
        }
        else if char == ")" {
            ignore = false
        }
        else if !ignore {
            newText.append(char)
            if char == "." {
                return newText
            }
        }
    }
    
    // shouldn't ever get here but,
    return newText
}

func boldTerms(text: String, terms: [String.SubSequence]) -> AttributedString {
    var markdown = text
    
    for term in terms {
        markdown = markdown.replacingOccurrences(of: term.lowercased(), with: "**\(term.lowercased())**").replacingOccurrences(of: term.capitalized, with: "**\(term.capitalized)**")
    }
    
    return try! AttributedString(markdown: markdown)
}
