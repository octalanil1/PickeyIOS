//
//  ManageTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ManageTblCell: UITableViewCell {

    @IBOutlet weak var ViewCross: UIView!
    @IBOutlet weak var btnTickRight: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
