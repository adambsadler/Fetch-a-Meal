//
//  MealViewController.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import UIKit

class MealViewController: UIViewController, MealManagerDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mealList: UITableView!
    
    
    var mealManager = MealManager()
    var meals = [String]()
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealList.dataSource = self
        mealManager.delegate = self
        
        categoryLabel.text = category
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)")!
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { print(error); return }
            do {
                let result = try JSONDecoder().decode(MealByCategory.self, from: data!)
                let mealNames = result.meals.map{$0.strMeal}.sorted(by: <)
                self.meals.append(contentsOf: mealNames)
                DispatchQueue.main.async {
                    // populate table view
                    self.mealList.reloadData()
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func didUpdateMeal(_ mealManager: MealManager, meal: MealModel) {
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension MealViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mealList.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath)
        cell.textLabel?.text = meals[indexPath.row]
        return cell
    }
}
