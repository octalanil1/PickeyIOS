//
//  HeaderKitchenCell.swift
//  Pickey
//
//  Created by octal on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class HeaderKitchenCell: UITableViewCell {

    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodTitle: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var img_amt:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img_amt.layer.cornerRadius = 30
        img_amt.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
