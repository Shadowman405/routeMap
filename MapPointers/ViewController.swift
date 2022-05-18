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
    @IBOutlet weak var addAdressButton: UIButton!
    
    var annotationArray = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        routeButton.isHidden = true
        resetButton.isHidden = true
        setupUI()
    }
    
    private func setupUI() {
        resetButton.layer.cornerRadius = 15
        addAdressButton.layer.cornerRadius = 15
        routeButton.layer.cornerRadius = 15
    }
    
    
// MARK: - Buttons
    
    @IBAction func addAdressTaped(_ sender: UIButton) {
        alertAddAdress(title: "Add", placeholder: "Enter adress") { [self] text in
            setupPlacemark(adressPlace: text)
        }
    }
    
    @IBAction func routeTapped(_ sender: UIButton) {
        for index in 0...annotationArray.count - 2 {
            createDirectionRequest(startCoordinate: annotationArray[index].coordinate, destinationCoordinate: annotationArray[index + 1].coordinate)
        }
        map.showAnnotations(annotationArray, animated: true)
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)
        annotationArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true
    }
    
// MARK: - Placemarks logic
    
    private func setupPlacemark(adressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] placemarks, error in
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
    
// MARK: - Routes logic
    
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self.alertError(title: "Error", message: "Route is unvailable")
                return
            }
            
            var minRoute = response.routes[0]
            for route in response.routes {
                minRoute = (route.distance < minRoute.distance ) ? route : minRoute
            }
            
            self.map.addOverlay(minRoute.polyline)
        }
    }
}

// MARK: - Extension

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        return renderer
    }
}
