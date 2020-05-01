//
//  OrderCell.swift
//  Pickey
//
//  Created by octal on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMenuName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
