//
//  SignInVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 15/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- Outlets and Variables/Objects..............
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    
    var strEmail = ""
    var strPassword = ""
    //MARK:- System Defined Methods............
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        addInputAccessoryForTextFields(textFields: [txtEmail, txtPassword], dismissable: true, previousNextable: true)
        
        let isLogin = UserDefaults.standard.object(forKey: kIsRemeber) as? String
        if isLogin == "Yes"
        {
            btnRememberMe.isSelected = true
            txtEmail.text = appDelegate.getUserDefaultForKey(kEmail as NSString) as String?
            txtPassword.text = appDelegate.getUserDefaultForKey(kPassword as NSString) as String?
        }
        else
        {
            btnRememberMe.isSelected = false
        }
    }
    
    //MARK:- UIButton Actions..............
    @IBAction func btnSkipNow(_ sender: UIButton)
    {
        isNavigationFrom = "isFromSkipNow"
        self.appDelegate.showtabbar()
    }
    
    @IBAction func btnRememberMe(_ sender: UIButton)
    {
        if let button = sender as? UIButton
        {
            if button.isSelected
            {
                print("true")
                button.isSelected = false
                UserDefaults.standard.setValue("No", forKey: kIsRemeber)
                UserDefaults.standard.setValue("", forKey: kEmail)
                UserDefaults.standard.setValue("", forKey: kPassword)
            }
            else
            {
                print("false")
                button.isSelected = true
                UserDefaults.standard.setValue("Yes", forKey: kIsRemeber)
                UserDefaults.standard.setValue(txtEmail.text, forKey: kEmail)
                UserDefaults.standard.setValue(txtPassword.text, forKey: kPassword)
            }
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.checkValidation()
        {
            if self.appDelegate.isInternetAvailable() == true
            {
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.MethodLoginUserApi), with: nil)
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
        if self.txtEmail.text == ""
        {
            onShowAlertController(title: kError, message: emptyMobileNoAndEmailError)
            return false
        }
        else if txtPassword.text == ""
        {
            onShowAlertController(title: kError, message: emptyPasswordError)
            return false
        }
        return true
    }
   
    func LoginParameter() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(txtEmail.text!,forKey: kForgotEmail as NSCopying)
        dictUser.setObject(txtPassword.text!, forKey: kPassword as NSCopying)
        dictUser.setObject(kMobile, forKey: kType as NSCopying)
        
        dictUser.setObject("IPHONE", forKey: kDeviceType as NSCopying)
        var StrToken = "simulator"
        if  UserDefaults.standard.object(forKey: kDeviceToken) != nil
        {
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        dictUser.setObject(StrToken, forKey: kDeviceToken as NSCopying)
        return dictUser
    }
    @objc func MethodLoginUserApi()
    {
        getAllApiResults(Details: LoginParameter(), srtMethod: kMethodLogin) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        
                        let userData = data.object(forKey: "User") as! NSDictionary
                        let token = userData.object(forKey: kServerTokenKey)
                        
                        self.appDelegate.saveCurrentUser(currentUserdict: userData)
                        UserDefaults.standard.set(token, forKey: kServerTokenKey)
                        UserDefaults.standard.set("Yes", forKey: kLoginCheck)
                        self.appDelegate.currentLoginUser = self.appDelegate.getLoginUser()
                        if (data.object(forKey: "UserLocation") as! NSDictionary).count == 0
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
                            vc.isNavigation = "signup"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                            let userlocation = data.object(forKey: "UserLocation") as! NSDictionary
                            StrAddressID = String(format: "%@", arguments: [userlocation.object(forKey: kId) as! CVarArg])
                            StrAddresstype = String(format: "%@", arguments: [userlocation.object(forKey: kAddressType) as! CVarArg])
                            let lat = String(format: "%@", arguments: [userlocation.object(forKey: kLatitude) as! CVarArg])
                            Strlat = Double(lat) as! Double
                            let longt = String(format: "%@", arguments: [userlocation.object(forKey: kLongititude) as! CVarArg])
                            Strlong = Double(longt) as! Double
                            StrCurrentaddress = String(format: "%@", arguments: [userlocation.object(forKey: kAddress) as! CVarArg])
                            self.appDelegate.showtabbar()
                        }
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == knotVerified)
                    {
                        let RegisterData: NSDictionary = responseData?.value(forKey: kResponseDataDict) as! NSDictionary
                         let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                         vc.strOtpCode = RegisterData.valueForNullableKey(key: kOtp)
                         vc.strTempID = RegisterData.valueForNullableKey(key: kTempId)
                         vc.isNavigation = "signIn"
                         self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kUserDeactivate)
                    {
                        self.onShowAlertController(title: kError, message: responseData?.object(forKey: kMessage) as? String)
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
    @IBAction func btnSignup(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.isNavigation = "SignUpVC"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}



extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
