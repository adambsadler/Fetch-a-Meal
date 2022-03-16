//
//  CategoryManager.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import Foundation

protocol CategoryManagerDelegate {
    func didUpdateCategory(_ categoryManager: CategoryManager, categories: [Category])
    func didFailWithError(error: Error)
}

struct CategoryManager {
    
    
    var delegate: CategoryManagerDelegate?
    
    func getCategories() {
        let urlString = "\(mealURL)categories.php"
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
                    if let categories = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCategory(self, categories: categories)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ mealData: Data) -> [Category]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MealData.self, from: mealData)
            let categories = decodedData.categories
            return categories
        } catch {
            self.delegate?.didFailWithError(error: error)
            return []
        }
    }
}
