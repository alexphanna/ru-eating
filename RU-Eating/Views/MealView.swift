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
            List {
                if !meal.items.isEmpty {
                    Section("Items") {
                        ForEach(meal.items) { item in
                            Stepper {
                                Text(String((item.portion * item.servingsNumber).formatted(.number.precision(.fractionLength((item.portion * item.servingsNumber).remainder(dividingBy: 1) == 0 ? 0 : 1)))) + ((item.portion * item.servingsNumber) == 1 ? " \(item.servingsUnit) " : " \(item.servingsUnitPlural) ") + item.name)
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
            .overlay {
                if meal.items.isEmpty {
                    ContentUnavailableView {
                        Text("No Items")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    } description: {
                        Text("Add an item to get started.")
                    } actions: {
                        Button(action: { isSheetShowing = true }) {
                            Text("Add Item")
                        }
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
