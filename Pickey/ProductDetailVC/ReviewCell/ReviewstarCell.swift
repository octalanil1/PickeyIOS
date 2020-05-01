//
//  ReviewCell.swift
//  Pickey
//
//  Created by octal on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ReviewstarCell: UITableViewCell
{
    @IBOutlet weak var GFImg:UIImageView!
    @IBOutlet weak var SFImg:UIImageView!
    @IBOutlet weak var DFImg:UIImageView!
    @IBOutlet weak var viewRating:FloatRatingView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var ViewcontentReview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
