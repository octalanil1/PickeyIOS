//
//  OrderDetailCell.swift
//  Pickey
//
//  Created by octal on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var lblMenuQuantity: UILabel!
    @IBOutlet weak var lblRestaurentCloseTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
