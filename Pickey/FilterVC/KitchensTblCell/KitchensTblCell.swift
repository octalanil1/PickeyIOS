//
//  KitchensTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 28/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class KitchensTblCell: UITableViewCell {
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
