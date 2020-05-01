//
//  MenuTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class MenuTblCell: UITableViewCell {

    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var imgDish: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
