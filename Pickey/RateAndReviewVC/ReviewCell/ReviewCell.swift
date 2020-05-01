//
//  ReviewCell.swift
//  Picky
//
//  Created by octal on 20/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.masksToBounds = true
         backView.layer.cornerRadius = 3
        foodImgView.layer.masksToBounds = true
        foodImgView.layer.cornerRadius = 3
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.50
        backView.layer.shadowRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
