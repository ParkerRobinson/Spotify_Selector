//
//  CreateLobbyViewController.swift
//  SpotifySelector
//
//  Created by Sahil Naikwadi on 10/11/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Firebase
import SpotifyLogin
import Spartan
import FirebaseFirestore

class CreateLobbyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var setPlaylistCollectionView: UICollectionView!
    var lobbyInfo : Lobby!
    var playlistInfo = [[String]]()
    let cellIdentifier = "setPlaylistCell"
    @IBOutlet var lobbyNameTextField: UITextField!
    @IBOutlet var lobbyPasswordTextField: UITextField!
    @IBOutlet var confirmLobbyPasswordTextField: UITextField!
    var selectedPlaylist = [String]()
    var selectedPlaylistTracks = [String: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistInfo.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = setPlaylistCollectionView.dequeueReusableCell(withReuseIdentifier: "setPlaylistCell", for: indexPath) as! SetPlaylistCollectionViewCell
        cell.playlistName.text = playlistInfo[indexPath.item][0]
        if playlistInfo[indexPath.item][1] == "takecareFRONTCOVERFINALweb.jpq" {
            cell.playlistImageView.image = UIImage(named: "takecareFRONTCOVERFINALweb.jpq")
        }
        else {
            DispatchQueue.global(qos: .background).async {
                do
                {
                    let data = try Data.init(contentsOf: URL.init(string:self.playlistInfo[indexPath.item][1])!)
                    DispatchQueue.main.async {
                        let image: UIImage = UIImage(data: data)!
                        cell.playlistImageView.image = image
                    }
                }
                catch {
                    print("Can't find the image")
                }
            }
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPlaylist = playlistInfo[indexPath.item];
        self.selectedPlaylistTracks.removeAll()
        playlistTracks(playlistID: playlistInfo[indexPath.item][2])
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func playlistTracks(playlistID: String)
    {
        _ = Spartan.getPlaylistTracks(userId: "sahiln13", playlistId: playlistID, limit: 20, offset: 0, market: .us, success: { (pagingObject) in
            for i in 0..<pagingObject.items!.count {
                let playlistTrack = pagingObject.items[i].track
                let trackID = String(playlistTrack!.externalUrls["spotify"]!.dropFirst(31))
                self.selectedPlaylistTracks[trackID] = [playlistTrack!.name, playlistTrack!.artists[0].name, playlistTrack?.album.images[0].url] as? [String]
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if (lobbyNameTextField.text != "" &&
            lobbyPasswordTextField.text != "" &&
            confirmLobbyPasswordTextField.text != "" &&
            !selectedPlaylist.isEmpty)
        {
            let db = Firestore.firestore()
            var docRef: DocumentReference? = nil
            docRef = db.collection("lobbies").addDocument(data: [
                "name": lobbyNameTextField.text ?? "empty name",
                "password": lobbyPasswordTextField.text ?? "empty password",
                "playlistID": self.selectedPlaylist[2],
                "createUser": SpotifyLogin.shared.username ?? "",
                "users": [SpotifyLogin.shared.username],
                "songs": self.selectedPlaylistTracks
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
//                    print(self.selectedPlaylistTracks);
                    self.lobbyInfo = Lobby.init(name: self.lobbyNameTextField.text ?? "",
                                              password: self.lobbyPasswordTextField.text ?? "",
                                              id: docRef!.documentID,
                                              playlistID: self.selectedPlaylist[2],
                                              createUser: SpotifyLogin.shared.username ?? "",
                                              users: [SpotifyLogin.shared.username ?? ""],
                                              songs: self.selectedPlaylistTracks)
                    print("Document added with ID: \(docRef!.documentID)")
                    self.performSegue(withIdentifier: "Created Lobby", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Created Lobby" {
            
            // Obtain the object reference of the destination view controller
            let lobbyViewController = segue.destination as! LobbyViewController
            // Pass the data object to the downstream view controller object
            lobbyViewController.lobbyInformation = self.lobbyInfo
            
        }
    }
    
}
