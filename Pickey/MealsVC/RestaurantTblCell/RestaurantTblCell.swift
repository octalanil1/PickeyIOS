//
//  RestaurantTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class RestaurantTblCell: UITableViewCell {

    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var ViewRestaurant: UIView!
    @IBOutlet weak var ImgRestaurantImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
