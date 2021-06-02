//
//  FavoriteTableViewCell.swift
//  iPaths
//
//  Created by Lebron on 3/28/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var FavTitle: UILabel!
    @IBOutlet weak var FavDes: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
