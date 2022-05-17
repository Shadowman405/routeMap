//
//  ViewController.swift
//  MapPointers
//
//  Created by Maxim Mitin on 17.05.22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeButton.isHidden = true
        resetButton.isHidden = true

    }
    
    
// MARK: - Buttons
    
    @IBAction func addAdressTaped(_ sender: UIButton) {
        alertAddAdress(title: "Add", placeholder: "Enter adress") { text in
            print(text)
        }
    }
    
    @IBAction func routeTapped(_ sender: UIButton) {
        print("route tap")
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        print("reset tap")
    }
}

