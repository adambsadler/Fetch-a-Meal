//
//  MealListManager.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/21/22.
//

import Foundation

protocol MealListManagerDelegate {
    func didUpdateMealList(_ mealListManager: MealListManager, mealList: MealByCategory)
    func didFailWithError(error: Error)
}

struct MealListManager {
    
    var delegate: MealListManagerDelegate?
    
    func getMealByCategory(categoryName: String) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(categoryName)"
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
                    if let mealList = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMealList(self, mealList: mealList)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ mealListData: Data) -> MealByCategory? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MealByCategory.self, from: mealListData)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
