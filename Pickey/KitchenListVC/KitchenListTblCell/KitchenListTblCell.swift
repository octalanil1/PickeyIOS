//
//  KitchenListTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 30/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class KitchenListTblCell: UITableViewCell {
    
    @IBOutlet weak var backView: ShadowView!
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 3
        foodImgView.layer.masksToBounds = true
        foodImgView.layer.cornerRadius = 3
        
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.23
        backView.layer.shadowRadius = 4
        
    }

}
