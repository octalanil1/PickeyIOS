//
//  KitchenNameTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 26/03/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class KitchenNameTblCell: UITableViewCell {

    @IBOutlet weak var lblKitchenName: UILabel!
    @IBOutlet weak var lblOrderBy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
