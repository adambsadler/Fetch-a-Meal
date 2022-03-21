//
//  ViewController.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CategoryManagerDelegate {
    
    var categoryManager = CategoryManager()
    var categoryPickerOptions = [String]()
    var categorySelected = ""
    var currentCategory = "Beef"

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryManager.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker?.selectRow(1, inComponent: 0, animated: true)
        
        categoryManager.getCategories()
    }
    
    func didUpdateCategory(_ categoryManager: CategoryManager, category: Category) {
        self.categoryPickerOptions = category.categories.map{$0.strCategory}.sorted(by: <)
        DispatchQueue.main.async {
            self.categoryPicker.reloadAllComponents()
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
    
    @IBAction func categorySelectedPressed(_ sender: UIButton) {
        self.categorySelected = currentCategory
        performSegue(withIdentifier: "ToMeals", sender: self)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCategory = categoryPickerOptions[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(categoryPickerOptions[row])"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMeals" {
            if let vc = segue.destination as? MealViewController {
                vc.category = self.categorySelected
            }
        }
    }
}

