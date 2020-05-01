//
//  DateWisePlanTblCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 31/03/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class DateWisePlanTblCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CollViewCalender: UICollectionView!
    @IBOutlet weak var CollViewMealsList: UICollectionView!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
