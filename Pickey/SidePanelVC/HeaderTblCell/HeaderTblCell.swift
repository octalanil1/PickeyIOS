//
//  HeaderTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 25/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class HeaderTblCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
