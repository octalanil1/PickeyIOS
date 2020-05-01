//
//  DeliveryTimeCell.swift
//  Pickey
//
//  Created by octal on 02/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class DeliveryTimeCell: UICollectionViewCell {
    @IBOutlet weak var txtTo: UILabel!
    @IBOutlet weak var txtFrom: UILabel!
        @IBOutlet weak var mview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()//E5E6E7,229,230,231
        mview.layer.borderWidth = 0.5
        mview.layer.borderColor = UIColor.lightGray.cgColor
        mview.layer.cornerRadius = 2
        
        txtTo.layer.cornerRadius = 2
        txtTo.layer.borderColor = UIColor.lightGray.cgColor
        txtTo.layer.borderWidth = 0.5
        
        txtFrom.layer.cornerRadius = 2
        txtFrom.layer.borderColor = UIColor.lightGray.cgColor
        txtFrom.layer.borderWidth = 0.5
        // Initialization code
    }

}
