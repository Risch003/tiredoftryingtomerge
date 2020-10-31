//
//  HomeCoachViewController.swift
//  WisHope
//
//  Created by Cameron Risch on 10/24/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit

class HomeCoachViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.frame = CGRect(x: 160, y: 100, width: 100, height: 100)
        image.layer.cornerRadius = 0.5 * image.bounds.size.width

        // Do any additional setup after loading the view.
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
