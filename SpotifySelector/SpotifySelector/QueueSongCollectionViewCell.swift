//
//  QueueSongCollectionViewCell.swift
//  SpotifySelector
//
//  Created by Sahil Naikwadi on 10/23/18.
//  Copyright © 2018 Group8. All rights reserved.
//

import UIKit

class QueueSongCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var songCoverImageView: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingUpButton: UIButton!
    @IBOutlet var ratingDownButton: UIButton!
    @IBOutlet var cellContentView: UIView!
    
    override func awakeFromNib() {
        songCoverImageView.layer.cornerRadius = 20
        songCoverImageView.clipsToBounds = true
        cellContentView.layer.cornerRadius = 10
    }
    
}
