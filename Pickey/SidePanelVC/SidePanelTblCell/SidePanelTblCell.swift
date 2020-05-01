//
//  SidePanelTblCell.swift
//  PepperCorn
//
//  Created by sunil-ios on 7/13/18.
//  Copyright © 2018 NInehertz013. All rights reserved.
//

import UIKit

class SidePanelTblCell: UITableViewCell {

    
    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var btnRightArrow: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
