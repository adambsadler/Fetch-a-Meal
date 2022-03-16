//
//  ViewController.swift
//  Fetch a Meal
//
//  Created by Adam Sadler on 3/15/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var categoryPickerOptions = [String]()

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { print(error); return }
            do {
                let result = try JSONDecoder().decode(Category.self, from: data!)
                self.categoryPickerOptions = result.categories.map{$0.strCategory}.sorted(by: <)
                DispatchQueue.main.async {
                    self.categoryPicker.reloadAllComponents()
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }

    @IBAction func chooseCategoryPressed(_ sender: UIButton) {
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
    
}

