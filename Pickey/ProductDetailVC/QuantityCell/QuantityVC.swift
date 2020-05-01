//
//  QuantityVC.swift
//  Pickey
//
//  Created by octal on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class QuantityVC: UITableViewCell {

    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblNumberOfOrder: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblQuantityPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
