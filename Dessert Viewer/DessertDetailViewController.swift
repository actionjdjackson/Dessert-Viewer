//
//  DessertDetailViewController.swift
//  Dessert Viewer
//
//  Created by Jacob Jackson on 12/23/23.
//

import UIKit

class DessertDetailViewController: UIViewController {
    
    var selectedDessert : Any?
    var dessertName : String?
    var dessertInstructions : String?
    var ingredientsList : [String] = []
    var measurementsList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDessertDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var dessertNameLabel: UILabel!
    @IBOutlet var ingredientsCollection: [UILabel]!
    @IBOutlet var measurementCollection: [UILabel]!
    
    func displayDetails() {
        dessertNameLabel.text = dessertName
        instructionsLabel.text = dessertInstructions
        for n in Range(0...19) {
            if ingredientsList[n] != "" {
                ingredientsCollection[n].text = ingredientsList[n]
            } else {
                ingredientsCollection[n].text = ""
            }
            if measurementsList[n] != "" {
                measurementCollection[n].text = measurementsList[n]
            } else {
                measurementCollection[n].text = ""
            }
        }
    }
    
    func loadDessertDetails() {
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(selectedDessert!)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
            
                    if let details = json["meals"] as? [[String:Any]] {
                        let firstDetails = details[0]
                        if let name = firstDetails["strMeal"] as? String {
                            self.dessertName = name
                            if let instructions = firstDetails["strInstructions"] as? String {
                                self.dessertInstructions = instructions
                                for n in Range(1...20) {
                                    self.ingredientsList.append(firstDetails["strIngredient\(n)"] as? String ?? "")
                                    self.measurementsList.append(firstDetails["strMeasure\(n)"] as? String ?? "")
                                }
                                DispatchQueue.main.async {
                                    self.displayDetails()
                                }
                            } else {
                                self.dessertInstructions = "Sorry, no recipe instructions were found."
                            }
                        } else {
                            self.dessertName = "Sorry, no recipe name was found."
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
