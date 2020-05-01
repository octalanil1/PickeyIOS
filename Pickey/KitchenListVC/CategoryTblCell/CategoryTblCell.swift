//
//  CategoryTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 21/04/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

//class ShadowButton : UIButton
//{
//    var rowIndex = 0
//    var sectionIndex = 0
//}

class CategoryTblCell: UITableViewCell {

    @IBOutlet weak var btnAddToCart: ShadowButton!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMenuDescription: UILabel!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    var rowIndex = -1
    var sectionIndex = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
