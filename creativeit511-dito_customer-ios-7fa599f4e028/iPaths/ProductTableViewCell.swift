//
//  ProductTableViewCell.swift
//  iPaths
//
//  Created by Lebron on 3/29/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productStyle: UILabel!
    @IBOutlet weak var projectAmount: UILabel!
    @IBOutlet weak var addproduct: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
