//
//  MealByCategory.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/16/22.
//

import Foundation

struct MealByCategory: Codable {
    let meals: [MealListItem]
}

struct MealListItem: Codable {
    let strMeal: String
}
