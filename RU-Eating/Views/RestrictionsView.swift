//
//  AllergenView.swift
//  MenRU
//
//  Created by alex on 9/7/24.
//

import SwiftUI

struct RestrictionsView : View {
    @Bindable var settings: Settings
    @State private var isTextFieldShowing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var ingredient: String = ""
    
    private var tapGesture: some Gesture {
        isTextFieldShowing ? (TapGesture().onEnded {
            withAnimation(.easeOut) {
                isTextFieldShowing = false
                ingredient = ""
            }}) : nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if settings.restrictions.count == 0 && !isTextFieldShowing {
                    Text("No Ingredients")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Ingredients you've added will appear here.")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    Button("Add Ingredient", action: showTextField)
                        .padding()
                }
                else {
                    List {
                        Section {
                            ForEach(settings.restrictions, id: \.self) { restriction in
                                Text(restriction)
                            }
                            .onDelete(perform: { settings.restrictions.remove(atOffsets: $0) })
                            if isTextFieldShowing {
                                TextField("Ingredient Name", text: $ingredient)
                                    .submitLabel(.done)
                                    .focused($isTextFieldFocused)
                                    .onSubmit {
                                        isTextFieldShowing = false
                                        if !ingredient.isEmpty {
                                            settings.restrictions.append(ingredient.trimmingCharacters(in: .whitespaces))
                                            ingredient = ""
                                        }
                                    }
                                    .onTapGesture { }
                            }
                        } footer: {
                            if isTextFieldShowing {
                                Text("Enter dietary restrictions singularly for increased filtering accuracy, for example enter \"Peanut\", not \"Peanuts\". Dietary restrictions are not case-sensitive.")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dietary Restrictions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: showTextField) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
        .gesture(tapGesture)
    }
    
    func showTextField() {
        withAnimation(.easeIn) {
            isTextFieldShowing = true
            isTextFieldFocused.toggle()
        }
    }
}
