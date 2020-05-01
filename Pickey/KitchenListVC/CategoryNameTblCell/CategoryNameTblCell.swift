//
//  CategoryNameTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 22/04/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class CategoryNameTblCell: UITableViewCell {

    @IBOutlet weak var viewCategory: ShadowView!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var lblCategoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
