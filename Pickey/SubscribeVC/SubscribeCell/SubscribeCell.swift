//
//  SubscribeCell.swift
//  Picky
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit

class SubscribeCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foodImgView.layer.masksToBounds = true
        foodImgView.layer.cornerRadius = 3
        viewShadow.layer.cornerRadius = 5
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowRadius = 1
        backView.layer.cornerRadius = 3
        backView.layer.shadowOpacity = 0.10
        backView.layer.masksToBounds = false;
        backView.clipsToBounds = false;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//@IBDesignable extension UIButton {
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//}
