//
//  FeedCell.swift
//  BasicSnapchat
//
//  Created by Hasan Kaya on 26.05.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var SnapimageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
