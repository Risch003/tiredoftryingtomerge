//
//  LoginViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 2/16/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//
// MARK: - TODO:
//              2FA, logintapped -> make sure error displays as multiple lines

import UIKit
import FirebaseAuth
import FirebaseFunctions
import Firebase

/// Controls login storyboard

var usersRole = ""

class LoginViewController: UIViewController {
    //let db = Firestore.firestore()
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    lazy var functions = Functions.functions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        setUpElements()
    }

    /// Calls functions made in ../Helpers/Utilties.swift to add styles to the buttons with outlets above
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton )
    }


    ///When login is tapped will format text entered by the user and call firebase auth functions to log the user in.
    ///If error: will display to the user what went wrong
    ///If successful: keeps track of users email and uid with class defined in ../Models/User.swift
    ///   then calls updateUserStatus to mark presence in database
    ///   then manually segues to home
    /// - Parameter sender: login button
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                User.email = email
                User.uid = Auth.auth().currentUser!.uid
                updateUserStatus(uid: Auth.auth().currentUser!.uid, online: true)
                
                self.functions.httpsCallable("setfcm").call(["uid": Auth.auth().currentUser!.uid,
                                                        "token": User.fcm]) { (result, error) in
                  if let error = error as NSError? {
                    if error.domain == FunctionsErrorDomain {
                      //let code = FunctionsErrorCode(rawValue: error.code)
                      //let message = error.localizedDescription
                      //let details = error.userInfo[FunctionsErrorDetailsKey]
                    }
                    // ...
                  }
                  print("logged in /n")
                                                            
                
                }
                usersRole = User.uid
                self.trasitionToHome()
            }
        }
    }
    
    
    /// Manally sugues to ../Storyboards/Home.storyboard
    func trasitionToHome(){
        let db = Firestore.firestore()
        var role = ""
//        let homeTabBarController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? UITabBarController
//        view.window?.rootViewController = homeTabBarController
//        view.window?.makeKeyAndVisible()
        db.collection("users").document(usersRole).getDocument { (doc, err) in
                    if err == nil{
                        if doc != nil && doc!.exists{
                            let documentData = doc!.data()
                            role = (documentData!["role"] as! String)
                            if (role == "coach"){
                                self.performSegue(withIdentifier: "coach", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "recov", sender: nil)
                                
                            }
                            
                        }
                    }
                }
        
        //performSegue(withIdentifier: "coach", sender: nil)
    }
}

/// Calls cloudsotre function to update user presence. Makes post with body of uid and online
/// - Parameters:
///   - uid: firebase uid of user signing in
///   - online: boolean indecation online or offline
func updateUserStatus(uid: String, online: Bool){
    // Prepare URL
        let url = URL(string: "https://us-central1-wishope-247fd.cloudfunctions.net/appFuncs/update-user-presence")
        guard let requestUrl = url else { fatalError() }

        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        //generate string
        let myString = "uid=\(uid)&online=\(online)"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = myString;
        print(myString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        print(request.httpBody as Any)
    
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    //display error if this doesnt work
                }
        }
        task.resume()
    
}
