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

    @IBAction func showDessertsList(_ sender: UIButton) {
        performSegue(withIdentifier: "showDessertList", sender: self)
    }
    
}

