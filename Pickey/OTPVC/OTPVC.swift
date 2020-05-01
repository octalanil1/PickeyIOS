//
//  OTPVC.swift
//  HPD
//
//  Created by Sunil Pradhan on 25/03/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class OTPVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt1: UITextField!
   
    var isNavigation = ""
    var strOtpCode = ""
    var strTempID = ""
    
    var DictRegisterParameter = NSDictionary()
   // var dictForgotPass = NSDictionary()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txt1.layer.borderColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0).cgColor
        txt2.layer.borderColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0).cgColor
        txt3.layer.borderColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0).cgColor
        txt4.layer.borderColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0).cgColor
        
        txt1.layer.borderWidth = 1.0
        txt2.layer.borderWidth = 1.0
        txt3.layer.borderWidth = 1.0
        txt4.layer.borderWidth = 1.0
        
        txt1.layer.cornerRadius = 5.0
        txt2.layer.cornerRadius = 5.0
        txt3.layer.cornerRadius = 5.0
        txt4.layer.cornerRadius = 5.0
        
        addInputAccessoryForTextFields(textFields: [txt1, txt2, txt3, txt4], dismissable: true, previousNextable: true)
        
        txt1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txt2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txt3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txt4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.fieldFillAuto()
    }
    
    @IBAction func btnVerify(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
         strOtpCode = "\(String(describing: txt1.text!))\(String(describing: txt2.text!))\(String(describing: txt3.text!))\(String(describing: txt4.text!))"
       
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.VerifyOTPApi), with: nil)
        }
        else
        {
            self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
        }
    
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendOTP(_ sender: UIButton)
    {
        if appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.OtpResendApi), with: nil)
        }
        else
        {
            self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
        }
    }
    
    // MARK: - UITextFieldDelegate...........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        let text = textField.text
        
        if (text?.utf16.count)! >= 1{
            switch textField{
            case txt1:
                txt2.becomeFirstResponder()
            case txt2:
                txt3.becomeFirstResponder()
            case txt3:
                txt4.becomeFirstResponder()
            case txt4:
                txt4.resignFirstResponder()
            default:
                break
            }
        }else
        {
            switch textField{
            case txt4:
                txt3.becomeFirstResponder()
            case txt3:
                txt2.becomeFirstResponder()
            case txt2:
                txt1.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func CheckValidation() -> Bool
    {
        var isGo = true
        var errorMessage = ""
        
        if txt1.text == "" && txt2.text == "" && txt3.text == "" && txt4.text == ""
        {
            isGo = false
            errorMessage = emptySMSCodeError
        }
        else if "\(String(describing: txt1.text!))\(String(describing: txt2.text!))\(String(describing: txt3.text!))\(String(describing: txt4.text!))" != strOtpCode
        {
            isGo = false
            errorMessage = emptySMSCodeError
        }
        if !isGo
        {
            onShowAlertController(title: kError , message: errorMessage)
        }
        return isGo
    }
    
    
    //MARK:- User Defind Methods............
    
    func fieldFillAuto()  {
        
        if isNavigation == "ForgotPasswordVC"
        {
           // strOtpCode = (dictForgotPass.object(forKey: kResponseDataDict) as! NSDictionary).valueForNullableKey(key: kOtp)
            
            self.txt1.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 0)])"
            self.txt2.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 1)])"
            self.txt3.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 2)])"
            self.txt4.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 3)])"
        }
        else
        {
            self.txt1.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 0)])"
            self.txt2.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 1)])"
            self.txt3.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 2)])"
            self.txt4.text = "\(self.strOtpCode[ self.strOtpCode.index(self.strOtpCode.startIndex, offsetBy: 3)])"
        }
       
    }
    
    //MARK:- OtpResend API Integration.............
    func OtpResendParam() -> NSMutableDictionary
    {
//
//        tmp_id:5
//        Verify_type:signup or forgot

        let dict = NSMutableDictionary()
        if isNavigation == "ForgotPasswordVC"
        {
            dict.setObject(strTempID, forKey: kTempId as NSCopying)
            dict.setObject("forgot", forKey: kVerifyType as NSCopying)
        }
        else
        {
            dict.setObject(strTempID, forKey: kTempId as NSCopying)
            dict.setObject("signup", forKey: kVerifyType as NSCopying)
        }
        
        return dict
    }
    
    
    @objc func OtpResendApi()
    {
        getAllApiResults(Details: OtpResendParam(), srtMethod: kMethodResendOtp) { (responseData, error) in
            
            if error == nil
            {
                self.hideActivity()
                DispatchQueue.main.async {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.strOtpCode = (responseData?.object(forKey: kResponseDataDict)as! NSDictionary).valueForNullableKey(key: kOtp)
                        self.fieldFillAuto()
                    }
                    else
                    {
                        self.onShowAlertController(title: kError , message: responseData?.object(forKey: kMessage)! as! String?)
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: kError, message: "Having some issue.Please try again.")
                }
            }
        }
    }
  
    //MARK:- Verify OTP API Integration.............
    func VerifyOTPParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        
        if isNavigation == "ForgotPasswordVC"
        {
            dict.setObject(strTempID, forKey:kTempId as NSCopying)
            dict.setObject("forgot", forKey:kVerifyType as NSCopying)
            dict.setObject(strOtpCode, forKey:kOtp as NSCopying)
        }
        else
        {
            dict.setObject(strTempID, forKey:kTempId as NSCopying)
            dict.setObject("signup", forKey:kVerifyType as NSCopying)
            dict.setObject(strOtpCode, forKey:kOtp as NSCopying)
            
            dict.setObject(kDeviceName, forKey: kDeviceType as NSCopying)
            
            var StrToken = "simulator"
            
            if  UserDefaults.standard.object(forKey: kDeviceToken) != nil
            {
                StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
            }
            dict.setObject(StrToken, forKey: kDeviceToken as NSCopying)
        }
                
        
        return dict
    }
    
    @objc func VerifyOTPApi()
    {
        getAllApiResults(Details: VerifyOTPParam(), srtMethod: kMethodOTPVerify) { (responseData, error) in
            
            if error == nil
            {
                self.hideActivity()
                DispatchQueue.main.async {
                if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                {
                    let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                    
                    if self.isNavigation == "ForgotPasswordVC"
                    {
                        let objResetPassword = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                        objResetPassword.resetuser_id = self.strTempID
                        self.navigationController?.pushViewController(objResetPassword, animated: true)
                    }
                    else
                    {
                       // let userData = data.object(forKey: "User") as! NSDictionary
                        let token = data.object(forKey: kServerTokenKey)
                        
                        self.appDelegate.saveCurrentUser(currentUserdict: data)
                        UserDefaults.standard.set(token, forKey: kServerTokenKey)
                        UserDefaults.standard.set("Yes", forKey: kLoginCheck)
                        self.appDelegate.currentLoginUser = self.appDelegate.getLoginUser()
                       
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
                        vc.isNavigation = "signup"
                        self.navigationController?.pushViewController(vc, animated: true)
                        //self.appDelegate.showtabbar()
                    }
                    
                }
                else
                {
                    self.onShowAlertController(title: kError , message: responseData?.object(forKey: kMessage)! as! String?)
                }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: kError, message: "Having some issue.Please try again.")
                }
            }
        }
    }
}


extension NSDictionary
{
    func valueForNullableKey(key : String) -> String
    {
        if self.value(forKey: key) == nil
        {
            return ""
        }
        if self.value(forKey: key) is NSNull
        {
            return ""
        }
        if self.value(forKey: key) is NSNumber
        {
            return String(describing: self.value(forKey: key) as! NSNumber)
        }
        else
        {
            return self.value(forKey: key) as! String
        }
    }
    
    @objc func dictionaryByReplacingNullsWithBlanks()->NSDictionary
    {
        let replaced: NSMutableDictionary = self.mutableCopy() as! NSMutableDictionary
        let blank = ""
        
        for strKey in self.keyEnumerator()
        {
            let object: AnyObject = self.object(forKey: strKey) as AnyObject
            
            if object is NSNull
            {
                replaced.setObject(blank, forKey: strKey as! NSCopying)
            }
            else if object is NSDictionary
            {
                replaced.setObject(object.dictionaryByReplacingNullsWithBlanks(), forKey: strKey as! NSCopying)
            }
            else if object is NSArray
            {
                replaced.setObject((object as! NSArray).arrayByReplacingNullsWithBlanks(), forKey: strKey as! NSCopying)
            }
        }
        
        return replaced.copy() as! NSDictionary
    }
}

extension NSArray
{
    func arrayByReplacingNullsWithBlanks() -> NSArray
    {
        let replaced:NSMutableArray = self.mutableCopy() as! NSMutableArray
        let blank = ""
        
        for idx in 0..<replaced.count
        {
            let object = replaced.object(at: idx)
            if object is NSNull
            {
                replaced.replaceObject(at: idx, with: blank)
            }
            else if object is NSDictionary
            {
                replaced.replaceObject(at: idx, with: (object as! NSDictionary).dictionaryByReplacingNullsWithBlanks())
            }
            else if object is NSArray
            {
                replaced.replaceObject(at: idx, with: (object as! NSArray).arrayByReplacingNullsWithBlanks())
            }
        }
        
        return replaced.copy() as! NSArray
    }
}
