//
//  DriverTableViewCell.swift
//  iPaths
//
//  Created by Lebron on 3/29/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet weak var viewDetails: UISwitch!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverTime: UILabel!
    @IBOutlet weak var driverAmont: UILabel!
    @IBOutlet weak var driverPlateNumber: UILabel!
    @IBOutlet weak var invoiceNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
