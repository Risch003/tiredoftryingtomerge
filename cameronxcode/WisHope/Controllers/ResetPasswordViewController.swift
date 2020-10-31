//
//  ResetPasswordViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 5/12/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import FirebaseAuth



class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    
    /// adds styles to elemets ../Helpers/Utilities.swift
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(resetPasswordButton)
    }
    
    /// provides error information and calls for reset if no error
    /// - Parameter sender: reset button
    @IBAction func resetPasswordTapped(_ sender: Any) {
        guard let email = emailTextField.text,
        email != ""
        else {
            errorLabel.text = "Please enter an email for password reset"
            errorLabel.alpha = 1.0
            return
        }
        resetPassword(email: email, onSuccess: {
            self.errorLabel.text = "email has been sent"
            self.errorLabel.textColor = UIColor.blue
            self.errorLabel.alpha = 1.0
            
        }) { (errorMessage) in
            self.errorLabel.text = "something went wrong"
            self.errorLabel.textColor = UIColor.red
            self.errorLabel.alpha = 1.0
        }

    }
    
    /// firebase auth reset password call
    /// - Parameters:
    ///   - email: user email
    ///   - onSuccess: onSuccess callback
    ///   - onError: onError callback
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            }
            else{
                onError(error!.localizedDescription)
            }
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
