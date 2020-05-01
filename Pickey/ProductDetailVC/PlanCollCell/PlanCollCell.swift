//
//  PlanCollCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 30/03/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class PlanCollCell: UICollectionViewCell {

    @IBOutlet weak var imgCheckUnCheck: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblDaysCount: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
