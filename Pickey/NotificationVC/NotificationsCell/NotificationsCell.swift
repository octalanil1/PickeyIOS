//
//  NotificationsCell.swift
//  Picky
//
//  Created by octal on 20/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
