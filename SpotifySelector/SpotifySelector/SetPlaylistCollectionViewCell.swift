//
//  SetPlaylistCollectionViewCell.swift
//  SpotifySelector
//
//  Created by Sahil Naikwadi on 10/11/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class SetPlaylistCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var playlistImageView: UIImageView!
    @IBOutlet var cellContentView: UIView!
    @IBOutlet var playlistName: UILabel!
    @IBOutlet var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        playlistImageView.layer.cornerRadius = 20
        playlistImageView.clipsToBounds = true
        cellContentView.layer.cornerRadius = 10
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                selectedImageView.image = UIImage(named: "Confirmation.png")
            }
            else {
                selectedImageView.image = nil
            }
        }
    }
}
