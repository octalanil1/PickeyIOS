//
//  RateAndReviewCell.swift
//  Picky
//
//  Created by octal on 20/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    @IBOutlet weak var RatingView: FloatRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foodImgView.layer.masksToBounds = true
        foodImgView.layer.cornerRadius = 3
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 5
        
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.23
        backView.layer.shadowRadius = 4
         }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
