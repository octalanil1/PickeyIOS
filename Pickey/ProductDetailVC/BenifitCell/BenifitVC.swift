//
//  BenifitVC.swift
//  Pickey
//
//  Created by octal on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class BenifitVC: UITableViewCell {
    @IBOutlet weak var viewImmunity: UIView!
    @IBOutlet weak var viewBone: UIView!
    @IBOutlet weak var viewBrain: UIView!
    @IBOutlet weak var Viewcontent: UIView!
    @IBOutlet weak var tblTimesSlot: UITableView!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
