//
//  CartCategoryTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 25/04/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class CartCategoryTblCell: UITableViewCell {

    @IBOutlet weak var btnDeletePlan: ShadowButton!
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblKitchenName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
