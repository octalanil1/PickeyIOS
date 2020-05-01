//
//  FAQTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 14/03/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class FAQTblCell: UITableViewCell {

    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblQuetion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
