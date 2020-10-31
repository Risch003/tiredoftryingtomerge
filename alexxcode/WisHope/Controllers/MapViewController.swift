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
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var map: MKMapView!
    

    
    @IBAction func filterTapped(_ sender: Any) {
        bottomSheetController.present(bottomVC, on: self)
    }
    
    @IBAction func centerLocationTapped(_ sender: Any) {
    }
    
   
    
    var center = CLLocationCoordinate2D(latitude: 43.038902,longitude: -87.906471)
    
    static var locsArray = [Location]()
    let db = Firestore.firestore()
    let bottomSheetController = NBBottomSheetController()
    let bottomVC = MapBottomSheetController()
    let annotationBottomSheet = NBBottomSheetController()
    
    
    let imageBottomSheet = NBBottomSheetController()
    let imageAC = AnnotationTableCell()
    
    
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
    
    func fillBottomSheet() {
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
        let row7 = TableRows.init(type: "No Type", color: UIColor.systemIndigo)
        bottomVC.tableRowsArray.append(row7)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillBottomSheet()
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
                    let address = data["address"] as? String ?? ""
                    let zip = data["zip"] as? String ?? ""
                    let website = data["website"] as? String ?? ""
                    let state = data["state"] as? String ?? ""
                    let phone = data["phone"] as? String ?? ""
                    
                    
                    
                    var coordinates = CLLocationCoordinate2D()
                    coordinates.latitude = lat
                    coordinates.longitude = long
                    MapViewController.locsArray.append(Location(city: city, coordinates: coordinates, name:name, type:type, address: address, website: website, phone: phone, state: state, zip: zip))
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
            let annotation = CustomPin(lat: location.coordinates.latitude, long: location.coordinates.longitude)
            annotation.title = (location.name)
            annotation.type = location.type
            annotation.address = location.address
            annotation.zip = location.zip
            annotation.state = location.state
            annotation.website = location.website
            annotation.city = location.city
            annotation.phone = location.phone
            map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? CustomAnnotationView
        var customPin: CustomPin?
        if annotation is MKUserLocation
        {
            return nil
        }
        if annotation is CustomPin
        {
            customPin = (annotation as! CustomPin)
            

        }
        

        if annotationView == nil{
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
      
            annotationView?.canShowCallout = true //Set this to false if making a custom callout
            }else{
                annotationView?.annotation = annotation
            }
            
            //Put case statement and change images
        if let customPin = customPin{
            annotationView?.image = customPin.newPinImage()
            annotationView?.address = customPin.address
            annotationView?.zip = customPin.zip
            annotationView?.city = customPin.city
            annotationView?.phone = customPin.phone
            annotationView?.state = customPin.state
            annotationView?.website = customPin.website
            annotationView?.type = customPin.type
            
        } else {
            annotationView?.image = UIImage(named: "no_Type")
            
        }
        
        
        
            return annotationView
            
        }
        

    
    
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // set bottomAC to annotation clicked class
            let bottomAC = AnnotationClicked()
            
                // if the names of the annotations equal
                if let annotationTitle = view.annotation?.title
                        {
                    //set the bottom view controllers to self
                    bottomAC.mapVC = self
                    bottomVC.mapVC = self
                    
                    //create images for the bottom sheet
                    let imageAddress = UIImage.init(named: "address")
                    let phone =  UIImage.init(named: "map_phone")
                    let website = UIImage.init(named: "map_website")
                    let pinImage = UIImage.init(named: "adolesents")
                    
                    // create a view with class custom annotation view
                    let view = view as? CustomAnnotationView
                    
                    // create the rows when an annotation is clicked
                    let row1 = ImageTableRows.init(type: annotationTitle!, image: imageAddress!)
                    let row2 = ImageTableRows.init(type: (view?.type!)!, image: pinImage!)
                    let row4 = ImageTableRows.init(type: (view?.phone!)!, image: phone!)
                    let row3 = ImageTableRows.init(type: "\(String(describing: view?.address)) \(String(describing: view?.city))\(String(describing: view?.state))\(String(describing: view?.zip))", image: imageAddress!)
                    let row5 = ImageTableRows.init(type: (view?.website!)!, image: website!)
                    
                   // append the bottom sheet with the table rows array
                    bottomAC.tableRowsArray.append(row1)
                    bottomAC.tableRowsArray.append(row2)
                    bottomAC.tableRowsArray.append(row3)
                    bottomAC.tableRowsArray.append(row4)
                    bottomAC.tableRowsArray.append(row5)

                    //present the bottom sheet
                    annotationBottomSheet.present(bottomAC, on: self)
                    
            }
            
            let pin = view.annotation
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: pin!.coordinate, span: span)
            // Lets "Get Directions" button apear when pin is clicked with proper coordinates
//            for site in MapViewController.locsArray {
//                if(site.coordinates.latitude == region.center.latitude){
//                    print(site.name)
//                }
//            }
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            #warning("Pin deselected, do something here")
            
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
