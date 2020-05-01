//
//  OrderCell.swift
//  Pickey
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class OrderDeliveryCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnConfirm: ShadowButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
