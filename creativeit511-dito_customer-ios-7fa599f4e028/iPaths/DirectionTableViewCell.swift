//
//  DirectionTableViewCell.swift
//  iPaths
//
//  Created by Lebron on 4/7/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

    @IBOutlet weak var directImage: UIImageView!
    @IBOutlet weak var directTitle: UILabel!
    @IBOutlet weak var directDes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
