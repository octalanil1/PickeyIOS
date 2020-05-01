//
//  SubscrptionListCell.swift
//  Pickey
//
//  Created by octal on 22/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class SubscrptionListCell: UITableViewCell {

    @IBOutlet weak var btnChoosePlan: ShadowButton!
     @IBOutlet weak var lblPrice: UILabel!
     @IBOutlet weak var lblDays: UILabel!
     @IBOutlet weak var planView: UIView!
     @IBOutlet weak var ViewcontentSubplan: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
