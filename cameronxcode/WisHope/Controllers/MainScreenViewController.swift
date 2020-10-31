//
//  MainScreenViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 4/22/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var mainScreenSignInButton: UIButton!
    
    @IBOutlet weak var mainScreenSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    /// adds syles to buttons ../Helpers/Utilities.swift
    func setUpElements(){
        Utilities.styleFilledButton(mainScreenSignUpButton)
        Utilities.styleFilledButton(mainScreenSignInButton)
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
