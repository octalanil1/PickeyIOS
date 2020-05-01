//
//  DeliveryAddressTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 05/02/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class DeliveryAddressTblCell: UITableViewCell {

    @IBOutlet weak var lblKitchenName: UILabel!
    @IBOutlet weak var btnChangeAddress: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
