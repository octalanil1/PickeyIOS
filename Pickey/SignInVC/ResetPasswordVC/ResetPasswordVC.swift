//
//  ResetPasswordVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 17/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnConfrimSubmit: ShadowButton!
    
    var resetuser_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ConfirmResetPassword(_ sender:UIButton)
    {
        self.view.endEditing(true)
        if self.checkValidation()
        {
            if self.appDelegate.isInternetAvailable() == true
            {
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.ResetPassword), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
    }
    
    //MARK:- UItextFeild Validation Method...........
    func checkValidation() -> Bool
    {
        if self.txtNewPassword.text == ""
        {
            onShowAlertController(title: kError, message: emptyNewPasswordError)
        }
        else if txtNewPassword.text!.count < 7
        {
            onShowAlertController(title: kError, message: validNewPasswordError)
        }
        else if self.txtConfirmPassword.text == ""
        {
            onShowAlertController(title: kError, message: emptyConfirmPassword)
        }
        else if self.txtNewPassword.text != self.txtConfirmPassword.text
        {
            onShowAlertController(title: kError, message: missMatchPasswordError)
        }
        
        return true
    }
    
    func ResetPassParameter() -> NSMutableDictionary
    {
        let dictuser = NSMutableDictionary()
        dictuser.setObject(resetuser_id, forKey: kUserId as NSCopying)
        dictuser.setObject(self.txtConfirmPassword.text!, forKey: kPassword as NSCopying)
        
        return dictuser
    }
    
    //MARK:- ResetPassword API
    @objc func ResetPassword()
    {
        getAllApiResults(Details: ResetPassParameter(), srtMethod: kMethodResetPassword) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
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
}
