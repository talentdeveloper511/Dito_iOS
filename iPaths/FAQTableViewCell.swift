//
//  FAQTableViewCell.swift
//  iPaths
//
//  Created by Marko Dreher on 10/9/18.
//  Copyright © 2018 Marko Dreher. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var answerText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
