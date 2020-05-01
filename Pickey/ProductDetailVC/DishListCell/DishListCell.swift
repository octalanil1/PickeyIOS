//
//  DishListCell.swift
//  Pickey
//
//  Created by octal on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class DishListCell: UITableViewCell {

    @IBOutlet weak var lblFoodTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var ViewcontentDish: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
