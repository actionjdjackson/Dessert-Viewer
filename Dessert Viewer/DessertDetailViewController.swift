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
    }
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var dessertNameLabel: UILabel!
    //collection of 20 ingredients labels
    @IBOutlet var ingredientsCollection: [UILabel]!
    //collection of 20 measurement labels
    @IBOutlet var measurementCollection: [UILabel]!
    
    func displayDetails() {
        // Fill in all the labels with their respective values
        dessertNameLabel.text = dessertName
        instructionsLabel.text = dessertInstructions
        
        for n in Range(0...19) {
            // Since we already checked for nil values and replaced them with empty strings, we'll just put the lists directly into their respective collections and if it's blank, that's ok because it won't show anything, which is what we want for the extra ingredient/measureent placeholders.
            ingredientsCollection[n].text = ingredientsList[n]
            measurementCollection[n].text = measurementsList[n]
            
        }
    }
    
    
    func loadDessertDetails() {
        
        // If the URL is valid, move on, otherwise, return and do nothing
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(selectedDessert!)") else { return }
        
        // Set up a URLSession with the above URL and if data is available when calling this API endpoint, continue, otherwise, return and do nothing
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                // Serialize JSON object from data coming from the above URL API call
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    
                    // Grab the JSON object "meals"
                    if let details = json["meals"] as? [[String:Any]] {
                        
                        // Grab the first (and only) meal in the meals array
                        let firstDetails = details[0]
                        
                        // Grab the name of the meal
                        if let name = firstDetails["strMeal"] as? String {
                            
                            self.dessertName = name
                            
                            // Grab the instructions for the meal
                            if let instructions = firstDetails["strInstructions"] as? String {
                                
                                self.dessertInstructions = instructions
                                
                                // Create arrays of both ingredients and measurements
                                // 1-20 as they are labeled in the API
                                for n in Range(1...20) {
                                    self.ingredientsList.append(firstDetails["strIngredient\(n)"] as? String ?? "")
                                    self.measurementsList.append(firstDetails["strMeasure\(n)"] as? String ?? "")
                                }
                                
                                // If we're going to change things in the UI (through displayDetails() function), we need to be in the main thread, thus the DispatchQueue.main.async
                                DispatchQueue.main.async {
                                    self.displayDetails()
                                }
                                
                            } else {
                                // if the dessert instructions are nil...
                                self.dessertInstructions = "Sorry, no recipe instructions were found."
                            }
                            
                        } else {
                            // if the dessert name is nil...
                            self.dessertName = "Sorry, no recipe name was found."
                        }
                    }
                }
                // catch if something went wrong with the JSON serialization
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        // get going with the downloading of data from the API endpoint at the top of this function...
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
