//
//  ItemView.swift
//  MenRU
//
//  Created by alex on 9/6/24.
//

import SwiftUI
import SwiftSoup

struct ItemView: View {
    let facts = [
        "Calories" : "Calories",
        "Total Fat" : "Total Fat",
        "Tot. Carb" : "Total Carbohydrates",
        "Sat. Fat" : "Saturated Fat",
        "Dietary Fiber" : "Dietary Fiber",
        "Trans Fat" : "Trans Fat",
        "Sugars" : "Sugars",
        "Cholesterol" : "Cholesterol",
        "Protein" : "Protein",
        "Sodium" : "Sodium"
    ]
    
    @State var item: Item
    @State private var nutrition = [NutritionFact]()
    @State private var ingredients : String = ""
    
    var body : some View {
        NavigationStack {
            List {
                Section("Nutrition Facts") {
                    ForEach(nutrition) { fact in
                        LabeledContent(fact.nutrient, value: fact.amount)
                    }
                }
                Section("Ingredients") {
                    Text(ingredients).font(.footnote).italic().foregroundStyle(.gray)
                }
            }
            .navigationTitle(item.name)
            .task {
                nutrition = try! await fetchNutrition(itemID: item.id)
                
                ingredients = try! await fetchIngredients(itemID: item.id)
            }
        }
    }
    
    struct NutritionFact: Hashable, Identifiable {
        let nutrient: String
        let amount: String
        let id = UUID()
    }
    
    func fetchNutrition(itemID: String) async throws -> [NutritionFact] {
        let url = URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + itemID + "*1")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        
        let elements = try! doc.select("table td, div#nutritional-info p.strong").array()
        
        var nutrition = [NutritionFact]();
        var nutrient = ""
        for element in elements {
            let text = try! element.text()
            var isFact = false;
            for fact in Array(facts.keys) {
                if text.contains(fact) {
                    isFact = true
                    nutrient = fact
                    break
                }
            }
            
            if isFact {
                let textArray = text.split(separator: "\u{00A0}")
                
                nutrition.append(NutritionFact(nutrient: facts[nutrient]!, amount: String(textArray[1])))
            }
        }
        
        return nutrition;
    }
    
    func fetchIngredients(itemID: String) async throws -> String {
        let url = URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + itemID + "*1")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        
        let elements = try! doc.select("div.col-md-12 > p").array()
        
        let text = try! elements[0].text()
        let textArray = text.split(separator: "\u{00A0}")
        
        return String(textArray[textArray.count - 1]).capitalized;
    }
}
