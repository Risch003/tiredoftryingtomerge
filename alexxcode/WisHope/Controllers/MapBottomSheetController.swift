//
//  MapBottomSheetController.swift
//  WisHope
//
//  Created by Doug Cash on 3/24/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapBottomSheetController: UITableViewController {
    
    var tableRowsArray = [TableRows]()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableCell") as! filterTableCell
        cell.cellLabel?.text = "\(tableRowsArray[indexPath.row].type)"
        cell.cellLabel?.textColor = tableRowsArray[indexPath.row].color
        cell.cellLabel?.textAlignment = NSTextAlignment.left
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "filterTableCell", bundle: nil), forCellReuseIdentifier: "filterTableCell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MapBottomSheetController.filtered=true
        filterAnnotations(locations: MapBottomSheetController.filteredTypes)
        let returnedMapVC = mapVC as! MapViewController
        if(MapBottomSheetController.checkedFilters.isEmpty){
            returnedMapVC.createAnnotations(locations: MapViewController.locsArray)
        }
        else{
        returnedMapVC.createAnnotations(locations: MapBottomSheetController.filteredLocs)
        }
    }
    
    func filterAnnotations(locations: [String]){
        MapBottomSheetController.filteredTypes = [String]()
        MapBottomSheetController.filteredLocs = [Location]()
        if (MapBottomSheetController.checkedFilters.contains(0)){
            MapBottomSheetController.filteredTypes.append("ADOLESCENTS")
        }
        if(MapBottomSheetController.checkedFilters.contains(1)){
            MapBottomSheetController.filteredTypes.append("HOMELESS SHELTER")
        }
        if(MapBottomSheetController.checkedFilters.contains(2)){
            MapBottomSheetController.filteredTypes.append("OUTPATIENT")
        }
        if(MapBottomSheetController.checkedFilters.contains(3)){
            MapBottomSheetController.filteredTypes.append("RESIDENTIAL")
        }
        if(MapBottomSheetController.checkedFilters.contains(4)){
            MapBottomSheetController.filteredTypes.append("RESOURCE / COMM ORG")
        }
        if(MapBottomSheetController.checkedFilters.contains(5)){
            MapBottomSheetController.filteredTypes.append("SOBER LIVING")
        }
        if(MapBottomSheetController.checkedFilters.contains(6)){
            MapBottomSheetController.filteredTypes.append("")
        }
        for location in MapViewController.locsArray{
            if(MapBottomSheetController.filteredTypes.contains(location.type)){
                MapBottomSheetController.filteredLocs.append(location)
            }
        }
    }
}
