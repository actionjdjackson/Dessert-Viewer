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
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {

                    if let meals = json["meals"] as? [[String:Any]] {
                        self.desserts = meals
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desserts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let dessert = self.desserts?[indexPath.row] {
            if let dessertName = dessert["strMeal"] as? String {
                cell.textLabel?.text = dessertName
                cell.accessoryType = .disclosureIndicator
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDessertDetail", sender: self)
        
    }

    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! DessertDetailViewController
         if let indexPath = tableView.indexPathForSelectedRow {
             let dessert = self.desserts?[indexPath.row]
             destinationVC.selectedDessert = dessert!["idMeal"]
         }
     }

}
