//
//  AccountTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class AccountTblCell: UITableViewCell {

    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var imgTitle: UIImageView!
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
