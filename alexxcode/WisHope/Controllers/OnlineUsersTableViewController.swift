//
//  OnlineUsersTableViewController.swift
//  WisHope
//
//  Created by Kyle Cain on 8/10/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import UIKit
import FirebaseFunctions

class OnlineUsersTableViewController: UITableViewController{
    lazy var functions = Functions.functions()
    var allOnlineUsers:[OnlineUsers] = []
    let server = "https://us-central1-wishope-247fd.cloudfunctions.net/appFuncs/online-users"
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        findOnlineUsers()
        super.viewDidLoad()
        
    }
    /// calls firestore function to get list of online users
    func findOnlineUsers(){
         let url = URL(string: server)!

             let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                 
                 guard let data = data else { return }
                 //print(String(data: data, encoding: .utf8)!)
                 do {
                                //let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    self.allOnlineUsers = try decoder.decode([OnlineUsers].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(self.allOnlineUsers)
                            } catch {
                                print("error:\(error)")
                            }

             }
             task.resume()
    }
    
    func callUserFCM(ruid: String, cuid: String){
        self.functions.httpsCallable("calluser").call(["ruid": ruid, "cuid": cuid, "type": "Video"]) { (result, error) in
                         if let error = error as NSError? {
                           if error.domain == FunctionsErrorDomain {
                             //let code = FunctionsErrorCode(rawValue: error.code)
                             //let message = error.localizedDescription
                             //let details = error.userInfo[FunctionsErrorDetailsKey]
                           } 
                           // ...
                         }
                         print("calling \n\n\n\n\n\n\n\n")
                                                                   
                       
                       }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allOnlineUsers.count
    }

    
    var userFullName: String = ""
    var userUID: String = ""
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineUserCell", for: indexPath)
        userFullName = allOnlineUsers[indexPath.row].firstName! + " " + allOnlineUsers[indexPath.row].lastName!
        userUID = allOnlineUsers[indexPath.row].uid!
        
        cell.textLabel!.text = userFullName
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userFullName = allOnlineUsers[indexPath.row].firstName! + " " + allOnlineUsers[indexPath.row].lastName!
        userUID = allOnlineUsers[indexPath.row].uid!
        self.performSegue(withIdentifier: "OnlineUserToCall", sender: nil)
    }
    
    //MARK:-THIS IS THE ONE YOU WANT
    
    /// makes a new view to transtion to containing the room sting we want to connect to
    /// - Parameters:
    ///   - segue: online user to call
    ///   - sender: sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        callUserFCM(ruid: userUID, cuid: User.uid)
        let videoCallView = segue.destination as! CommunicationViewController
        let nonSortedString = userUID + User.uid
        let sortedString = String(nonSortedString.sorted())
        
        //this is what will need to be changed with FCM integration
        videoCallView.roomString = sortedString
    }
}
