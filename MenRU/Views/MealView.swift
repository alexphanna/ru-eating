//
//  MealView.swift
//  MenRU
//
//  Created by alex on 9/8/24.
//

import SwiftUI

struct MealView: View {
    @State private var isSheetShowing: Bool = false
    @State private var meal: Category = Category(name: "Meal")
    
    var body: some View {
        NavigationStack {
            VStack {
                if meal.items.count == 0 {
                    Text("No Items")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Items you've added will appear here.")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    Button("Add Items", action: { isSheetShowing = true })
                        .padding()
                }
                else if meal.items.count > 0 {
                    List {
                        Section("Items") {
                            ForEach(meal.items) { item in
                                Stepper {
                                    Text(String(item.portion) + " " + item.name)
                                } onIncrement: {
                                    item.incrementPortion()
                                } onDecrement: {
                                    item.decrementPoriton()
                                    if item.portion == 0 {
                                        meal.items.removeAll(where: { $0.id == item.id } )
                                    }
                                }
                            }
                            .onDelete(perform: { meal.items.remove(atOffsets: $0) })
                        }
                        NutritionView(category: meal)
                    }
                }
            }
            .navigationTitle("Meal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isSheetShowing = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isSheetShowing) {
                AddItemsView(meal: meal)
            }
         }
    }
}
