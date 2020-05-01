//
//  OrderFromTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 05/02/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class OrderFromTblCell: UITableViewCell {

    @IBOutlet weak var lblPlanDay: UILabel!
    @IBOutlet weak var ViewShadow: ShadowView!
    @IBOutlet weak var btnDelete: ShadowButton!
    @IBOutlet weak var lblMenuPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnMinus: ShadowButton!
    @IBOutlet weak var btnPlus: ShadowButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgMenu.layer.cornerRadius = 8
        imgMenu.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
