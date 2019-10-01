//
//  UserTableViewCell.swift
//  imagePicker
//
//  Created by Phoenix McKnight on 10/1/19.
//  Copyright © 2019 Phoenix McKnight. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var activityOutlet: UIActivityIndicatorView!
    @IBOutlet weak var userLabe: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var pickImageFunction: (()->()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
