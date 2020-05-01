//
//  TopUPVC.swift
//  Pickey
//
//  Created by octal on 20/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class TopUPVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scroll: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var viewAmount: UIView!
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addInputAccessoryForTextFields(textFields: [txtAmount], dismissable: true, previousNextable: true)
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 1, initialSpringVelocity: 1.0,
                       options: .allowAnimatedContent, animations: {
                        self.view.center = CGPoint(x: self.view.center.x,y: self.view.center.y + self.view.frame.size.height)
        }) { (isFinished) in
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        if self.checkValidation()
        {
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 1, initialSpringVelocity: 1.0,
                           options: .allowAnimatedContent, animations: {
                            self.view.center = CGPoint(x: self.view.center.x,y: self.view.center.y + self.view.frame.size.height)
            }) { (isFinished) in
                self.removeFromParent()
                self.view.removeFromSuperview()
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCardVC") as! AddNewCardVC
            vc.isNavigation = "Wallet"
            vc.strWalletAmount = txtAmount.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   //MARK:- UItextFeild Validation Method...........
   func checkValidation() -> Bool
   {
    
    let strAmount = self.txtAmount.text!
    let intValidAmount = Int(strAmount)
    
    if self.txtAmount.text! == ""
    {
        onShowAlertController(title: kError, message: emptyAmountError)
        return false
    }
    else if intValidAmount! <= 0
    {
        onShowAlertController(title: kError, message: ValidAmountError)
        return false
    }
       return true
   }
}


