//
//  PlaceView.swift
//  RU Eating
//
//  Created by alex on 3/1/25.
//

import SwiftUI

struct PlaceView: View {
    @State var place: Place
    
    var body: some View {
        NavigationLink {
            NavigationStack {
                List {
                    LabeledContent("Campus", value: place.campus.description)
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
