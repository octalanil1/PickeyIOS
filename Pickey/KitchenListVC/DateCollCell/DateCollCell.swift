//
//  DateCollCell.swift
//  Pickey
//
//  Created by Sunil Pradhan on 20/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class DateCollCell: UICollectionViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeekDayName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    var cellindex: Int?
//    {
//        didSet
//        {
//            guard let index = cellindex else { return }
//            if index != 0
//            {
//                lblDate.textColor = UIColor.init(red: 149/255.0, green: 152/255.0, blue: 153/255.0, alpha: 1.0)
//                lblWeekDayName.textColor = UIColor.init(red: 149/255.0, green: 152/255.0, blue: 153/255.0, alpha: 1.0)
//            }
//            else
//            {
//                lblDate.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
//                lblWeekDayName.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
//            }
//        }
//    }
//    override var isSelected: Bool
//        {
//        didSet{
//           lblDate.textColor = isSelected ? UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0) : UIColor.init(red: 149/255.0, green: 152/255.0, blue: 153/255.0, alpha: 1.0)
//            lblWeekDayName.textColor = isSelected ? UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0) : UIColor.init(red: 149/255.0, green: 152/255.0, blue: 153/255.0, alpha: 1.0)
//
//        }
//    }
}
