//
//  MapViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 2/16/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//  Starting with functionality of Cemetary Project.

import UIKit
import MapKit
import Firebase
import NBBottomSheet

/// Controls map storyboard
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBAction func swipedUp(_ sender: Any) {
        bottomSheetController.present(bottomVC, on: self)
    }

    var center = CLLocationCoordinate2D(latitude: 43.038902,longitude: -87.906471)
    
    static var locsArray = [Location]()
    let db = Firestore.firestore()
    let bottomSheetController = NBBottomSheetController()
    let bottomVC = MapBottomSheetController()
    
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
       }
       locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomVC.mapVC = self
        let row1 = TableRows.init(type: "Adolescents", color: UIColor.systemOrange)
        bottomVC.tableRowsArray.append(row1)
        let row2 = TableRows.init(type: "Homeless Shelter", color: UIColor.systemPurple)
        bottomVC.tableRowsArray.append(row2)
        let row3 = TableRows.init(type: "Outpatient", color: UIColor.systemPink)
        bottomVC.tableRowsArray.append(row3)
        let row4 = TableRows.init(type: "Residential", color: UIColor.systemTeal)
        bottomVC.tableRowsArray.append(row4)
        let row5 = TableRows.init(type: "Resource / Comm Org", color: UIColor.systemBlue)
        bottomVC.tableRowsArray.append(row5)
        let row6 = TableRows.init(type: "Sober Living", color: UIColor.systemYellow)
        bottomVC.tableRowsArray.append(row6)
        
        locationManager.delegate = self
        self.view.backgroundColor = .black
        map.delegate = self
        map.mapType = MKMapType.standard
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           locationManager.startUpdatingLocation()
        }
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
        map.setRegion(region, animated: true)
        db.collection("map_data").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let city = data["city"] as? String ?? ""
                    let lat = (data["latitude"] as? NSString ?? "0.0").doubleValue
                    let long = (data["longitude"] as? NSString ?? "0.0").doubleValue
                    let name = data["name"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    var coordinates = CLLocationCoordinate2D()
                    coordinates.latitude = lat
                    coordinates.longitude = long
                    MapViewController.locsArray.append(Location(city: city, coordinates: coordinates, name:name, type:type))
                }
            }
            if(MapBottomSheetController.filtered){
                self.createAnnotations(locations: MapBottomSheetController.filteredLocs)
            }
            else{
                self.createAnnotations(locations: MapViewController.locsArray)
            }
        }
    }
    
    /// Generations pins on map
    /// - Parameter locations: takes array of locations (defined: ../Models/Locations.swift)
    func createAnnotations(locations: [Location]) {
        map.removeAnnotations(map.annotations)
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = (location.name)
            annotation.coordinate = location.coordinates
            map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "AnnotationView"
        var view: MKMarkerAnnotationView
       
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeView.annotation = annotation
            view = dequeView
            view.canShowCallout = true
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let button = UIButton(type: .detailDisclosure)
            var size = CGSize()
            size.height = 100
            size.width = 100
            view.rightCalloutAccessoryView = button
        }
        return view
    }
    
    func resizedImage(image: UIImage, for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location = locations.last! as CLLocation
      let currentLocation = location.coordinate
      let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
      map.setRegion(coordinateRegion, animated: true)
      locationManager.stopUpdatingLocation()
   }
    
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print(error.localizedDescription)
   }
}
