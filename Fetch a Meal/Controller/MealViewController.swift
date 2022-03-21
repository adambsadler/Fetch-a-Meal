//
//  MealViewController.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import UIKit

class MealViewController: UIViewController, MealListManagerDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mealList: UITableView!
    
    var mealListManager = MealListManager()
    var meals = [String]()
    var category = ""
    var selectedMeal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealListManager.delegate = self
        mealList.dataSource = self
        
        categoryLabel.text = category
        
        mealListManager.getMealByCategory(categoryName: category)
        
    }
    
    func didUpdateMealList(_ mealListManager: MealListManager, mealList: MealByCategory) {
        let mealNames = mealList.meals.map{$0.strMeal}.sorted(by: <)
        self.meals.append(contentsOf: mealNames)
        DispatchQueue.main.async {
            self.mealList.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.mealList.indexPathForSelectedRow {
            self.selectedMeal = meals[indexPath.row]
        }
        if segue.identifier == "ToMealDetail" {
            let vc = segue.destination as! MealDetailViewController
            vc.mealName = self.selectedMeal
        }
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
