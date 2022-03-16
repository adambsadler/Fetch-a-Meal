//
//  Category.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import Foundation

struct Category: Decodable {
    let categories: [Name]
}

struct Name: Decodable {
    let strCategory: String
}
