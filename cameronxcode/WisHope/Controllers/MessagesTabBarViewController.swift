//
//  MessagesTabBarViewController.swift
//  WisHope
//
//  Created by Cameron Risch on 10/30/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit

class MessagesTabBarViewController: UITabBarController {

    @IBOutlet weak var communicationTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.communicationTabBar.frame = CGRect( x: 0, y: 0, width: 320, height: 50)
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
