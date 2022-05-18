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
    
    var annotationArray = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeButton.isHidden = true
        resetButton.isHidden = true

    }
    
    
// MARK: - Buttons
    
    @IBAction func addAdressTaped(_ sender: UIButton) {
        alertAddAdress(title: "Add", placeholder: "Enter adress") { [self] text in
            setupPlacemark(adressPlace: text)
        }
    }
    
    @IBAction func routeTapped(_ sender: UIButton) {
        print("route tap")
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        print("reset tap")
    }
    
    private func setupPlacemark(adressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("Минск, Притыцкого 78") { [self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                alertError(title: "Error", message: "Server unreacheable, try later")
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = adressPlace
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            annotationArray.append(annotation)
            
            if annotationArray.count > 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            
            map.showAnnotations(annotationArray, animated: true)
        }
    }
}

