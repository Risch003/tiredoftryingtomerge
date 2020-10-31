//
//  HomeViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 2/16/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import Firebase

/// controls home sotryboard
class HomeViewController: UIViewController {
    var role = ""
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
