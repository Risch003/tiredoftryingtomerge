///
//  MapBottomSheetController.swift
//  WisHope
//
//  Created by Doug Cash on 3/24/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AnnotationClicked: UITableViewController {
    
    var tableRowsArray = [ImageTableRows]()
    var mapVC : UIViewController = UIViewController()
    static var checkedFilters = [Int]()
    static var filteredTypes = [String]()
    static var filtered = false
    static var locsArray = [Location]()
    static var filteredLocs = [Location]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnotationTableCell") as! AnnotationTableCell
        cell.annotationLabel?.text = "\(tableRowsArray[indexPath.row].type)"
        cell.annotationImage?.image = tableRowsArray[indexPath.row].image
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "AnnotationTableCell", bundle: nil), forCellReuseIdentifier: "AnnotationTableCell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MapBottomSheetController.filtered=true
        let returnedMapVC = mapVC as! MapViewController
        if(MapBottomSheetController.checkedFilters.isEmpty){
            returnedMapVC.createAnnotations(locations: MapViewController.locsArray)
        }
        else{
        returnedMapVC.createAnnotations(locations: MapBottomSheetController.filteredLocs)
        }
    }
    
}
