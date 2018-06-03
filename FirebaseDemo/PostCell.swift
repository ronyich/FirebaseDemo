//
//  PostCell.swift
//  FirebaseDemo
//
//  Created by Ron Yi on 2018/6/1.
//  Copyright © 2018年 AppCoda. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var voteButton: LineButton! {
        didSet {
            voteButton.tintColor = .white
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
