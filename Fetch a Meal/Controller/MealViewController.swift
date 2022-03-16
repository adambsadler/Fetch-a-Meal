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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealManager.delegate = self
        
        }
    
    func didUpdateMeal(_ mealManager: MealManager, meal: MealModel) {
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
