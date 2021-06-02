//
//  MenuItemTVCell.swift
//  iPaths
//
//  Created by Lebron on 3/25/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class MenuItemTVCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
