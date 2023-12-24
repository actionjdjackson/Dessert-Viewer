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
                // make sure this JSON is in the format we expect
                // convert data to json
                //print("\(self.selectedDessert ?? 0)")
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    print(json)
                    // try to read out a dictionary
                    if let details = json["meals"] as? [[String:Any]] {
                        let firstDetails = details[0]
                        self.dessertName = firstDetails["strMeal"] as? String
                        self.dessertInstructions = firstDetails["strInstructions"] as? String
                        for n in Range(1...20) {
                            self.ingredientsList.append(firstDetails["strIngredient\(n)"] as? String ?? "")
                            self.measurementsList.append(firstDetails["strMeasure\(n)"] as? String ?? "")
                        }
                        DispatchQueue.main.async {
                            self.displayDetails()
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
