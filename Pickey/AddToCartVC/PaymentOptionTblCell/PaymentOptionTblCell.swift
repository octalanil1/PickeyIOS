//
//  PaymentOptionTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 05/02/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class PaymentOptionTblCell: UITableViewCell {

    @IBOutlet weak var lblMyWallet: UILabel!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var tblTimeSlot: UITableView!
    @IBOutlet weak var btnPromoCode: UIButton!
    @IBOutlet weak var btnCardChange: UIButton!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblUsedWalletAmount: UILabel!
    @IBOutlet weak var lblDiscountedPrice: UILabel!
    @IBOutlet weak var LblOrderPrice: UILabel!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var txtDeliveryNote: UITextView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
