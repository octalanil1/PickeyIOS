//
//  SavedCardTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 28/01/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class SavedCardTblCell: UITableViewCell {

    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var txtCardNo: UITextField!
    @IBOutlet weak var imgCard: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
