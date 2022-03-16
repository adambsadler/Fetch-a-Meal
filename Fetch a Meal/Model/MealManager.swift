//
//  MealManager.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import Foundation

protocol MealManagerDelegate {
    func didUpdateMeal(_ mealManager: MealManager, meal: MealModel)
    func didFailWithError(error: Error)
}

struct MealManager {
    let mealURL = "https://www.themealdb.com/api/json/v1/1/"
    
    var delegate: MealManagerDelegate?
    
    func getMealsByCategory(categoryName: String) {
        let urlString = "filter.php?c=\(categoryName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let meal = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMeal(self, meal: meal)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ mealData: Data) -> MealModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MealData.self, from: mealData)
            let name = decodedData.meals[0].strMeal
            let instructions = decodedData.meals[0].strInstructions
            let ingredients = [decodedData.meals[0].strIngredient1, decodedData.meals[0].strIngredient2, decodedData.meals[0].strIngredient3, decodedData.meals[0].strIngredient4, decodedData.meals[0].strIngredient5, decodedData.meals[0].strIngredient6, decodedData.meals[0].strIngredient7, decodedData.meals[0].strIngredient8, decodedData.meals[0].strIngredient9, decodedData.meals[0].strIngredient10, decodedData.meals[0].strIngredient11, decodedData.meals[0].strIngredient12, decodedData.meals[0].strIngredient13, decodedData.meals[0].strIngredient14, decodedData.meals[0].strIngredient15, decodedData.meals[0].strIngredient16, decodedData.meals[0].strIngredient18, decodedData.meals[0].strIngredient19, decodedData.meals[0].strIngredient20]
            let measurements = [decodedData.meals[0].strMeasure1, decodedData.meals[0].strMeasure2, decodedData.meals[0].strMeasure3, decodedData.meals[0].strMeasure4, decodedData.meals[0].strMeasure5, decodedData.meals[0].strMeasure6, decodedData.meals[0].strMeasure7, decodedData.meals[0].strIngredient8, decodedData.meals[0].strMeasure9, decodedData.meals[0].strMeasure10, decodedData.meals[0].strMeasure11, decodedData.meals[0].strMeasure12, decodedData.meals[0].strMeasure13, decodedData.meals[0].strMeasure14, decodedData.meals[0].strMeasure15, decodedData.meals[0].strMeasure16, decodedData.meals[0].strMeasure18, decodedData.meals[0].strMeasure19, decodedData.meals[0].strMeasure20]
            var actualIngredients = [String]()
            var actualMeasurements = [String]()
            for ingredient in ingredients {
                if ingredient != "" || ingredient != nil {
                    actualIngredients.append(ingredient!)
                }
            }
            for measurement in measurements {
                if measurement != "" || measurement != nil {
                    actualMeasurements.append(measurement!)
                }
            }
            let combinedArrays = zip(actualIngredients, actualMeasurements)
            let measuredIngredients = combinedArrays.map {
                $0.1 + " " + $0.0
            }
            let meal = MealModel(name: name, instructions: instructions!, ingredients: measuredIngredients)
            return meal
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
