//
//  MessagingViewController.swift
//  WisHope
//
//  Created by Cameron Risch on 10/30/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit

class MessagingViewController: UIViewController {

    @IBOutlet weak var segBar: UISegmentedControl!
    @IBOutlet weak var segView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func segmentAction(_ sender: Any) {
        switch segBar.selectedSegmentIndex {
        case 0:
            segView.backgroundColor = UIColor.red
        case 1:
            segView.backgroundColor = UIColor.green
        default:
            segView.backgroundColor = UIColor.white
        }
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
