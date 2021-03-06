//
//  CategoryManager.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/21/22.
//

import Foundation

protocol CategoryManagerDelegate {
    func didUpdateCategory(_ categoryManager: CategoryManager, category: Category)
    func didFailWithError(error: Error)
}

struct CategoryManager {
    
    var delegate: CategoryManagerDelegate?
    
    func getCategories() {
        let urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
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
                    if let category = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCategory(self, category: category)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ categoryData: Data) -> Category? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Category.self, from: categoryData)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
