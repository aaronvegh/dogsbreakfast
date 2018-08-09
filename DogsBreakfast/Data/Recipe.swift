//
//  Recipe.swift
//  DogsBreakfast
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import Foundation

struct RecipeResult: Codable {
    var title: String?
    var version: Double?
    var href: String?
    var results: [Recipe]?
}

struct Recipe: Codable {
    var title: String?
    var href: String?
    var ingredients: String?
    var thumbnail: String?
    
    var url: URL? {
        guard let href = href else { return nil }
        return URL(string: href)
    }
}
