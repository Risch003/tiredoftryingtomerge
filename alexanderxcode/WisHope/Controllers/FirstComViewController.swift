//
//  FirstComViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 9/2/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit

class FirstComViewController: UIViewController {
    @IBOutlet weak var videoCallButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(videoCallButton)
        videoCallButton.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func audioCallPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "audioCall", sender: self)
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
