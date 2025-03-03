//
//  PlaceView.swift
//  RU Eating
//
//  Created by alex on 3/1/25.
//

import SwiftUI

struct PlaceView: View {
    @State var place: any Place
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                List {
                    if (place is DiningHall) {
                        NavigationLink("Menu") {
                            MenuView(viewModel: MenuViewModel(place: place as! DiningHall))
                        }
                    }
                    else {
                        NavigationLink("Menu") {
                            SimpleMenuView(place: place as! Retail)
                        }
                    }
                    LabeledContent("Campus", value: place.campus.description)
                    LabeledContent {
                        Text(place.acceptsMealSwipes ? "Yes" : "No")
                            .foregroundStyle(place.acceptsMealSwipes ? .green : .red)
                    } label: {
                        Text("Accepts Meal Swipes")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { place.isFavorite = !place.isFavorite }) {
                            Image(systemName: place.isFavorite ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .navigationTitle(place.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        } label: {
            Text(place.name)
        }
    }
}
