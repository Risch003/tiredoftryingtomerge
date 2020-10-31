//
//  SignUpViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 2/24/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//
//  test
import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Make sure all fields are filled in"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Make sure password is at least 8 characters, contains a special character, and has a number"
        }
        return nil
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    /// processes all information in sign up form
    /// - Parameter sender: sign up button
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(message: error!)
        }
        else{
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //creates user in firebase and adds them to the database
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError(message: "Error creating user")
                }
                else{
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["firstName": firstName,
                                                                               "lastName": lastName,
                                                                               "email": email,
                                                                               "fcmToken": "",
                                                                               "online": false,
                                                                               "role": "recoveree",
                                                                               "uid": result!.user.uid]){ (error) in
                                                                                if error != nil{
                                                                                    self.showError(message: "Error saving user data")
                                                                                }
                    }
                    self.trasitionToHome()
                }
            }
        }
    }
    
    /// shows error message to user
    /// - Parameter message: error message
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    /// manually transitions to home storyboard ../Storyboards/Home.storyboard
    func trasitionToHome(){
        let homeTabBarController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? UITabBarController
        view.window?.rootViewController = homeTabBarController
        view.window?.makeKeyAndVisible()
    }
}
