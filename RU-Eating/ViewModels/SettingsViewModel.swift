//
//  SettingsViewModel.swift
//  RU Eating
//
//  Created by alex on 10/1/24.
//

import Foundation
import SwiftSoup

@Observable class SettingsViewModel {
    var settings: Settings
    var favoriteItems: [String]
    
    init(settings: Settings) {
        self.settings = settings
        self.favoriteItems = [String]()
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        for id in settings.favoriteItemsIDs {
            if let doc = try? await fetchDoc(url: URL(string: "https://menuportal23.dining.rutgers.edu/foodpronet/label.aspx?&RecNumAndPort=" + id + "*1")!) {
                favoriteItems.append(getName(doc: doc))
            }
        }
    }
    
    func getName(doc: Document) -> String {
        if let element = try? doc.select("div.col-md-9 > h2:not(:contains(Nutrition Report))").array().first {
            let text = try! element.text()
            return String(text).capitalized;
        }
        return ""
    }
}
