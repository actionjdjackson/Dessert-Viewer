//
//  DessertTableViewController.swift
//  Dessert Viewer
//
//  Created by Jacob Jackson on 12/23/23.
//

import UIKit

class DessertTableViewController: UITableViewController {

    var desserts : [[String:Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesserts()
    }

    
    func loadDesserts() {
        
        // If the URL is valid, continue, otherwise return and do nothing
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        // Create a URLSession with the above URL, and if data is returned, continue, otherwise, return and do nothing
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                // Serialize the JSON object in the data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {

                    // Grab all the meals that are desserts (as in the API call above)
                    if let meals = json["meals"] as? [[String:Any]] {
                        
                        // Save the array of dictionaries of desserts to the desserts variable
                        self.desserts = meals
                        
                        // In order to reload the table with the new desserts data, we must be in the main thread, thus the DispatchQueue.main.async
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                // If JSON Serialization doesn't work - i.e. there wasn't anything returned that was JSON - print an error and exit the program
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        // Move along with the downloading of the JSON data through the API URL above
        task.resume()
        
    }
    
    
    // MARK: - Table view data source

    // Only one section in the tableview - the name of the dessert
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // There should be as many tableview cells as there are desserts in the desserts list of dictionaries
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desserts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Grab the generic reusable cell for the tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // If there is a dessert for this index (i.e. it's not nil)
        if let dessert = self.desserts?[indexPath.row] {
            
            // Then if there is a name for the dessert (i.e. it's not nil)
            if let dessertName = dessert["strMeal"] as? String {
                
                // Set the cell's label to the dessert name
                cell.textLabel?.text = dessertName
                // Make sure the user knows it's clickable and will go to the detail view, by adding a disclosure indicator
                cell.accessoryType = .disclosureIndicator
            } else {
                print("Dessert name not found for number \(indexPath.row)")
            }
        } else {
            print("Dessert dictionary not found for number \(indexPath.row)")
        }
        // Return the filled cell
        return cell
    }

    // MARK: - Navigation
    
    // When a dessert name is clicked/selected...
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Perform segue to the dessert detail view controller
        performSegue(withIdentifier: "showDessertDetail", sender: self)
        
    }
    
    // Before the segue happens...
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
         // Grab the destination viewcontroller for the dessert details
         let destinationVC = segue.destination as! DessertDetailViewController
         
         // Grab (safely) the index for the selected row (dessert name)
         if let indexPath = tableView.indexPathForSelectedRow {
             
             // Grab the dessert that was clicked
             let dessert = self.desserts?[indexPath.row]
             
             // Grab the id for the dessert and put it into the DessertDetailViewController (destinationVC)
             destinationVC.selectedDessert = dessert!["idMeal"]
         }
     }

}
