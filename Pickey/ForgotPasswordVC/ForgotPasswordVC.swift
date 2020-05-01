//
//  ForgotPasswordVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addInputAccessoryForTextFields(textFields: [txtEmail], dismissable: true, previousNextable: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnConfirm(_ sender: UIButton)
    {
        if self.txtEmail.text == ""
        {
            onShowAlertController(title: kError, message: emptyEmailAddressError)
        }
        ForgotPassword()
    }
    @objc func ForgotPassword()
    {
        let dictuser = NSMutableDictionary()
        dictuser.setObject(self.txtEmail.text, forKey: kForgotEmail as NSCopying)
        
        getAllApiResults(Details: dictuser, srtMethod: kMethodForgot) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        
                        let RegisterData: NSDictionary = responseData?.value(forKey: kResponseDataDict) as! NSDictionary
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                        vc.strOtpCode = RegisterData.valueForNullableKey(key: kOtp)
                        vc.strTempID = RegisterData.valueForNullableKey(key: kUserId)
                        vc.isNavigation = "ForgotPasswordVC"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == ktokenExpire)
                    {
                        let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                        let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                            
                            self.appDelegate.clearData()
                        }
                        alert.addAction(actionAllow)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kUserDeactivate)
                    {
                        let alert = UIAlertController(title: "", message:responseData?.object(forKey: kMessage) as? String , preferredStyle: .alert )
                        
                        let actionAllow = UIAlertAction(title: "OK", style: .default) { alert in
                            
                            self.appDelegate.clearData()
                        }
                        alert.addAction(actionAllow)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        self.onShowAlertController(title: kError, message: responseData?.object(forKey: kMessage) as? String)
                    }
                }
                else
                {
                    self.onShowAlertController(title: kError, message: "Having some issue.Please try again.")
                }
            }
        }
    }
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
