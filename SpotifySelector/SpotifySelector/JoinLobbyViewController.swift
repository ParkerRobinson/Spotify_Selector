//
//  JoinLobbyViewController.swift
//  SpotifySelector
//
//  Created by Dhruv Patel on 11/09/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import FirebaseFirestore

class JoinLobbyViewController: UIViewController {

    var lobbyInfo : Lobby!
    var availableLobbies = [String:[String]]()
    
    @IBOutlet var lobbyName: UITextField!
    @IBOutlet var lobbyPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("lobbies").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.availableLobbies[document.data()["name"] as! String] = [document.data()["password"] as? String, document.documentID] as? [String]
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func joinLobbyClicked(_ sender: UIButton) {
        let name = lobbyName.text
        let password = lobbyPassword.text
        let lobbyIndex = availableLobbies.index(forKey: name!)
        if (lobbyIndex != nil && password == availableLobbies[name!]![0]) {
            let db = Firestore.firestore()
            let lobby = db.collection("lobbies").document(availableLobbies[name!]![1])
            lobby.getDocument { (document, error) in
                if let document = document, document.exists {
                    let lobbyDescription = document.data()!
                    self.lobbyInfo = Lobby.init(name: lobbyDescription["name"] as! String,
                                           password: lobbyDescription["password"] as! String,
                                           id: self.availableLobbies[name!]![1],
                                           playlistID: lobbyDescription["playlistID"] as! String,
                                           createUser: lobbyDescription["createUser"] as! String,
                                           users: lobbyDescription["users"] as! [String],
                                           songs: lobbyDescription["songs"] as! [String : [String]])
                    self.performSegue(withIdentifier: "Enter Lobby", sender: self)
                } else {
                    print("Lobby does not exist")
                }
            }
        }
        else {
            showAlertMessage(messageHeader: "Invalid Lobby Information", messageBody: "Please enter a valid lobby name or password!")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Enter Lobby" {
            
            // Obtain the object reference of the destination view controller
            let lobbyNav = segue.destination as! UINavigationController
            let lobbyViewController = lobbyNav.topViewController as! LobbyViewController
            // Pass the data object to the downstream view controller object
            lobbyViewController.lobbyInformation = self.lobbyInfo
            
        }
    }
    
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
}
