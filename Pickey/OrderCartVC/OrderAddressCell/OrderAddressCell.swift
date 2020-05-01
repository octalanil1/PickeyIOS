//
//  OrderAddressCell.swift
//  Pickey
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class OrderAddressCell: UITableViewCell {

   // @IBOutlet weak var ConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var lblBunchName: UILabel!
  //  @IBOutlet weak var viewCancelOrder: UIView!
    @IBOutlet weak var btnCancelOrder: ShadowButton?
    @IBOutlet weak var lblMode : UILabel?
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var lblRsetaurantName: UILabel!
   // @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var btnOrderStatus: ShadowButton!
    @IBOutlet weak var lblOrderNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
