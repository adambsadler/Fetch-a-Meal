//
//  MealViewController.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import UIKit

class MealViewController: UIViewController, MealManagerDelegate {
    
    @IBOutlet weak var mealList: UITableViewCell!
    var mealManager = MealManager()
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealManager.delegate = self
        print(category)
        }
    
    func didUpdateMeal(_ mealManager: MealManager, meal: MealModel) {
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
