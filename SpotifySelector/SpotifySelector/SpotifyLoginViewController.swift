//
//  SpotifyLoginViewController.swift
//  SpotifySelector
//
//  Created by Sahil Naikwadi on 10/3/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import SpotifyLogin
import Hero
import Spartan

class SpotifyLoginViewController: UIViewController {
    
    @IBOutlet var spotifyLoginButton: UIButton!
    public static var authorizationToken: String?
    public static var loggingEnabled: Bool = false
    var playlistInfo = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = SpotifyLoginButton(viewController: self,
                                        scopes: [.streaming,
                                                 .userReadTop,
                                                 .playlistReadPrivate,
                                                 .userLibraryRead])
        button.frame = spotifyLoginButton.frame
        spotifyLoginButton.isHidden = true
        self.view.addSubview(button)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)
        
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                print("Log In Failure!")
            }
            Spartan.authorizationToken = accessToken
        }
        getPlaylist()
        // Do any additional setup after loading the view.
    }
    
    @objc func loginSuccessful() {
        self.performSegue(withIdentifier: "loggedInWithSpotify", sender: self)
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getPlaylist() {
        _ = Spartan.getMyPlaylists(limit: 20, offset: 0, success: { (pagingObject) in
            // Get the playlists via pagingObject.items
            for i in 0..<pagingObject.items!.count {
                let playlistName = pagingObject.items[i].name
                var playlistImage = "takecareFRONTCOVERFINALweb.jpg"
                if pagingObject.items[i].images.count > 0 {
                    playlistImage = pagingObject.items[i].images[0].url
                }
                var playlistID = pagingObject.items[i].tracksObject.href
                playlistID = String(playlistID!.dropFirst(37).dropLast(7))
                let playlist = [playlistName, playlistImage, playlistID]
                self.playlistInfo.append(playlist as! [String])
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "loggedInWithSpotify" {
            
            // Obtain the object reference of the destination view controller
            let createLobbyNav = segue.destination as! UINavigationController
            let createLobbyViewController = createLobbyNav.topViewController as! CreateLobbyViewController
            // Pass the data object to the downstream view controller object
            createLobbyViewController.playlistInfo = self.playlistInfo
            
        }
    }

}
