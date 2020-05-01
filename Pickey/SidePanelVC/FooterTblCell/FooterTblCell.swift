//
//  FooterTblCell.swift
//  Triipbyt
//
//  Created by sunil-ios on 8/16/18.
//  Copyright © 2018 NInehertz013. All rights reserved.
//

import UIKit

class FooterTblCell: UITableViewCell {

    @IBOutlet weak var lblLogOut: UILabel!
    @IBOutlet weak var btnSwitchAdults: UIButton!
    @IBOutlet weak var btnlogOut: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
