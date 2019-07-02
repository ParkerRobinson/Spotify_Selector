//
//  Lobby.swift
//  SpotifySelector
//
//  Created by Sahil Naikwadi on 11/6/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import Foundation
import Spartan

struct Lobby {
    var name: String
    var password: String
    var id: String
    var playlistID: String
    var createUser: String
    var users: [String]
    var songs: [String: [String]]
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "password": password,
            "playlistID": playlistID,
            "createUser": createUser,
            "users": users,
            "songs": songs
        ]
    }
}

extension Lobby{
    init?(dictionary: [String : Any], id: String) {
        guard   let name = dictionary["name"] as? String,
                let password = dictionary["password"] as? String,
                let playlistID = dictionary["playlistID"] as? String,
                let createUser = dictionary["createUser"] as? String,
                let users = dictionary["users"] as? [String],
                let songs = dictionary["songs"] as? [String: [String]]
            else { return nil }
        
        self.init(name: name, password: password, id: id, playlistID: playlistID, createUser: createUser, users: users, songs: songs)
    }
}
