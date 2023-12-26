//
//  ViewController.swift
//  Dessert Viewer
//
//  Created by Jacob Jackson on 12/23/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Only thing this does is allow you to press a button to see the desserts list
    @IBAction func showDessertsList(_ sender: UIButton) {
        performSegue(withIdentifier: "showDessertList", sender: self)
    }
    
}

