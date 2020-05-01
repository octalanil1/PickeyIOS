//
//  ChangePasswordVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmNewPass: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- UItextFeild Validation Method...........
    func checkValidation() -> Bool
    {
        if self.txtCurrentPass.text == ""
        {
            onShowAlertController(title: kError, message: emptyCurrentPasswordError)
            return false
        }
        else if self.txtNewPass.text == ""
        {
            onShowAlertController(title: kError, message: emptyNewPasswordError)
            return false
        }
        else if txtNewPass.text!.count < 7
        {
            onShowAlertController(title: kError, message: validPasswordError)
            return false
        }
        else if self.txtConfirmNewPass.text == ""
        {
            onShowAlertController(title: kError, message: emptyConfirmPassword)
            return false
        }
        else if self.txtNewPass.text != self.txtConfirmNewPass.text
        {
            onShowAlertController(title: kError, message: missMatchPasswordError)
            return false
        }
        return true
    }
    
    @IBAction func btnConfirm(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.checkValidation()
        {
            if self.appDelegate.isInternetAvailable() == true
            {
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.MethodChangePasswordApi), with: nil)
            }
            else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
    }
    //MARK:- ApiChangePassoword
    @objc func MethodChangePasswordApi()
    {
        //        Header => token:jE6tyeOxSXlN8NiYFfJhjfhspg1IOiyLSNYOpIRBNyjlQgVLVjN4RFwY0ObI
        //        Body =>password:123456
        let dict = NSMutableDictionary()
        dict.setObject(self.txtConfirmNewPass.text, forKey: kPassword as NSCopying)
        dict.setObject(self.txtCurrentPass.text, forKey: kOldPassword as NSCopying)
        getallApiResultwithPostTokenMethod(Details: dict, strMethodname: kMethodChangePassword) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        
                        let alert = UIAlertController(title: "", message:responseData?.object(forKey: kMessage) as? String , preferredStyle: .alert )
                        
                        let actionAllow = UIAlertAction(title: "OK", style: .default) { alert in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(actionAllow)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
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
