//
//  LobbyViewController.swift
//  SpotifySelector
//
//  Created by Sahil Naikwadi on 10/23/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit
import Spartan

class LobbyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var lobbyInformation : Lobby?
    var songID : [String]!
    
    @IBOutlet var memberCountLabel: UILabel!
    @IBOutlet var viewMembersButton: UIButton!
    @IBOutlet var playlistNameLabel: UILabel!
    @IBOutlet var lobbyQueueCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        songID = Array(lobbyInformation!.songs.keys)
        memberCountLabel.text = "\(lobbyInformation?.users.count ?? 1) members listening"
        navigationItem.title = "\(lobbyInformation?.createUser ?? "Group 8")'s Lobby"
        memberCountLabel.adjustsFontSizeToFitWidth = true
        getPlaylistName()
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return 1;
        case 1:
            return lobbyInformation!.songs.count - 1;
        default:
            return 10;
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = lobbyQueueCollectionView.dequeueReusableCell(withReuseIdentifier: "queueSongCell", for: indexPath) as! QueueSongCollectionViewCell
        if (indexPath.section == 0) {
            cell.artistLabel.text = lobbyInformation!.songs[songID![indexPath.item]]![1]
            cell.songNameLabel.text = lobbyInformation!.songs[songID![indexPath.item]]![0]
            DispatchQueue.global(qos: .background).async {
                do
                {
                    let data = try Data.init(contentsOf: URL.init(string:self.lobbyInformation!.songs[self.songID![indexPath.item]]![2])!)
                    DispatchQueue.main.async {
                        let image: UIImage = UIImage(data: data)!
                        cell.songCoverImageView.image = image
                    }
                }
                catch {
                    print("Can't find the image")
                }
            }

        }
        else {
            cell.artistLabel.text = lobbyInformation!.songs[songID![indexPath.item + 1]]![1]
            cell.songNameLabel.text = lobbyInformation!.songs[songID![indexPath.item + 1]]![0]
            DispatchQueue.global(qos: .background).async {
                do
                {
                    let data = try Data.init(contentsOf: URL.init(string:self.lobbyInformation!.songs[self.songID![indexPath.item + 1]]![2])!)
                    DispatchQueue.main.async {
                        let image: UIImage = UIImage(data: data)!
                        cell.songCoverImageView.image = image
                    }
                }
                catch {
                    print("Can't find the image")
                }
            }
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let section = indexPath.section
            
            switch section
            {
            case 0:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nowPlayingHeader", for: indexPath) as! LobbyHeaderCollectionReusableView
                view.lobbySectionLabel.text = "now playing"
                // do any programmatic customization, if any, here
                return view
            case 1:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nowPlayingHeader", for: indexPath) as! LobbyHeaderCollectionReusableView
                view.lobbySectionLabel.text = "up next"
                // do any programmatic customization, if any, here
                return view
            default:
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nowPlayingHeader", for: indexPath)
                // do any programmatic customization, if any, here
                return view
            }
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nowPlayingHeader", for: indexPath)
        // do any programmatic customization, if any, here
        return view
    }
    
    func getPlaylistName() {
        let userId = lobbyInformation?.createUser
        let playlistId = lobbyInformation?.playlistID
        _ = Spartan.getUsersPlaylist(userId: userId!, playlistId: playlistId!, fields: ["name"], market: .us, success: { (playlist) in
            self.playlistNameLabel.text = "playlist: \(playlist.name as String)"
            self.playlistNameLabel.adjustsFontSizeToFitWidth = true
        }, failure: { (error) in
            print(error)
        })
    }
}
