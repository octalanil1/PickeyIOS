//
//  PromoCodeTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 27/01/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class PromoCodeTblCell: UITableViewCell {

    @IBOutlet weak var imgPromoCode: UIImageView!
    @IBOutlet weak var lblPromoCodeDescription: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var btnApplyCode: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
