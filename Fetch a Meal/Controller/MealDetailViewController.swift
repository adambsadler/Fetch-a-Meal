//
//  MealDetailViewController.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/16/22.
//

import UIKit

class MealDetailViewController: UIViewController, MealManagerDelegate {
    
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealInstructionsLabel: UITextView!
    @IBOutlet weak var ingredientList: UITableView!
    
    var mealManager = MealManager()
    var ingredients = [String]()
    var mealName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealManager.delegate = self
        ingredientList.dataSource = self
        
        mealManager.getMealByName(mealName: self.mealName)
        
    }

    func didUpdateMeal(_ mealManager: MealManager, meal: MealModel) {
        DispatchQueue.main.async {
            self.mealNameLabel.text = meal.name
            self.mealInstructionsLabel.text = meal.instructions
            self.ingredients.append(contentsOf: meal.ingredients)
            self.ingredientList.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension MealDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientList.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }
}
