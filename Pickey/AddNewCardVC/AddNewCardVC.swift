//
//  AddNewCardVC.swift
//  Pickey
//
//  Created by octal on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import Stripe

class AddNewCardVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    
    var dictOrder = NSMutableDictionary()
    var dateFormateSearch = DateFormatter()
    var datePicker1 = UIDatePicker()
    var toolBar1 = UIToolbar()
    var isSelectedWallet = false
    var isNavigation = ""
    var strWalletAmount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addInputAccessoryForTextFields(textFields: [txtName, txtCardNumber, txtExpiryDate, txtCVV], dismissable: true, previousNextable: true)
        
        self.datePicker.isHidden = true
        self.toolBar.isHidden = true
       
        if isNavigation == "Wallet"{
            lblPrice.text = "AED \(strWalletAmount)"
        }else{
            lblPrice.text = "AED \(dictOrder.valueForNullableKey(key: kAmount))"
        }
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
    
    @IBAction func btnBarDone(_ sender: UIBarButtonItem)
    {
        self.view.endEditing(true)
        self.datePicker.isHidden = true
        toolBar.isHidden = true
        txtExpiryDate.text = dateFormateSearch.string(from: self.datePicker.date)
    }
    
    @IBAction func btnBarCancel(_ sender: UIBarButtonItem)
    {
        self.view.endEditing(true)
        self.datePicker.isHidden = true
        self.toolBar.isHidden = true
    }
    
    func setInputViewDatePicker() {
          // Create a UIDatePicker object and assign to inputView
          let screenWidth = UIScreen.main.bounds.width
          datePicker1 = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        let now : Date = Date()
        datePicker1.minimumDate = now
        datePicker1.datePickerMode = .date
        datePicker1.date = now
        datePicker1.backgroundColor = UIColor.white
        dateFormateSearch  = DateFormatter()
        dateFormateSearch.dateFormat =  "MM/yy"
        self.txtExpiryDate.inputView = datePicker1 //3
          
          // Create a toolbar and assign it to inputAccessoryView
          toolBar1 = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
          let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
          let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
          let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone)) //7
          toolBar1.setItems([cancel, flexible, barButton], animated: false) //8
          self.txtExpiryDate.inputAccessoryView = toolBar1 //9
      }
      
      @objc func tapCancel() {
        //self.datePicker1.resignFirstResponder()
        self.datePicker1.removeFromSuperview()
        self.toolBar1.removeFromSuperview()
      }
      
      @objc func tapDone() {
          
        txtExpiryDate.text = dateFormateSearch.string(from: self.datePicker1.date)
       // self.datePicker1.resignFirstResponder()
        self.datePicker1.removeFromSuperview()
        self.toolBar1.removeFromSuperview()
      }
    
    @IBAction func btnTermsAndCondition(_ sender: UIButton)
    {
        if sender.isSelected == true
        {
            sender.isSelected = false
            isSelectedWallet = false
            print("Not Selected")
        }else{
            print("select Card")
            isSelectedWallet = true
            sender.isSelected = true
        }
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.checkValidation()
        {
            let date = dateFormateSearch.date(from: txtExpiryDate.text!)
            
            let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date!)
            
            let strExpMonth = calanderDate.month
            let strExpYear = calanderDate.year
            
            let cardParams = STPCardParams()
            cardParams.name = txtName.text
            
            cardParams.number = txtCardNumber.text
            cardParams.cvc = txtCVV.text
            cardParams.expMonth = UInt(strExpMonth!)
            cardParams.expYear = UInt(strExpYear!)
            
            self.windowShowActivity(text: "")
            
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                
                self.hideActivityFromWindow()
                //  print("payment token is", token)
                guard let token = token, error == nil else {
                    
                    self.onShowAlertController(title: "", message: (error! as NSError).userInfo["NSLocalizedDescription"] as? String)
                    return
                }
                if self.isNavigation == "Wallet"
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.windowShowActivity(text: "")
                        self.performSelector(inBackground: #selector(self.methodAddWalletApi(tokenId:)), with: token.tokenId)
                    }
                    else
                    {
                        self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                    }
                }
                else
                {
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.windowShowActivity(text: "")
                        self.performSelector(inBackground: #selector(self.methodPlaceOrderApi(tokenId:)), with: token.tokenId)
                    }
                    else
                    {
                        self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                    }
                }
                
            }
        }
    }
    
    //MARK:- UItextFeild Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 3
        {
            self.view.endEditing(true)
            setInputViewDatePicker()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string == ""
        {
            return true
        }
        if textField.tag == 2
        {
            if ((textField.text?.count)!>15)
            {
                return false
            }
        }
        if textField.tag == 3
        {
            if ((textField.text?.count)!>4)
            {
                return false
            }
        }
        if textField.tag == 4
        {
            if ((textField.text?.count)!>3)
            {
                return false
            }
        }
        return true
    }
    
    //MARK: - Date Method.............
    func logicalOneYearAgo(from: Date) -> Date
    {
        let gregorian : NSCalendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        
        var offsetComponents = DateComponents()
        offsetComponents.year = 0
        
        return gregorian.date(byAdding: offsetComponents, to: from as Date, options: NSCalendar.Options(rawValue: 0))!
    }
    
    //MARK:- UItextFeild Validation Method...........
    
    func checkValidation() -> Bool
    {
        if self.txtName.text == ""
        {
            onShowAlertController(title: kError, message: emptyFullNameError)
            return false
        }
        else if (self.txtName.text?.count)! < 3
        {
            onShowAlertController(title: kError, message: validFullNameError)
            return false
        }
        else if self.txtCardNumber.text == ""
        {
            onShowAlertController(title: kError, message: emptyCardNoError)
            return false
        }
        else if (self.txtCardNumber.text?.count)! < 8
        {
            onShowAlertController(title: kError, message: validAccountNoError)
            return false
        }
        else if self.txtExpiryDate.text == ""
        {
            onShowAlertController(title: kError, message: emptyExpiryError)
            return false
        }
        else if (self.txtExpiryDate.text?.count)! < 5
        {
            onShowAlertController(title: kError, message: emptyExpiryError)
            return false
        }
        else if txtCVV.text == ""
        {
            onShowAlertController(title: kError, message: emptyCVVError)
            return false
        }
        else if (self.txtCVV.text?.count)! < 3
        {
            onShowAlertController(title: kError, message: validCVVError)
            return false
        }
        return true
    }
    
    
    //MARK:- AddWallet API Integration.............
    
    func AddWalletParameters(tokenId : String) -> NSMutableDictionary
    {
        var userDict = NSMutableDictionary()
        userDict.setObject(tokenId, forKey: kPaymentToken as NSCopying)
        userDict.setObject(strWalletAmount, forKey: kAmount as NSCopying)
        return userDict
    }
    
    @objc func methodAddWalletApi(tokenId:String)
    {
        getallApiResultwithPostTokenMethod(Details: AddWalletParameters(tokenId: tokenId), strMethodname: kMethodAddWallet) { (responseData, error) in
            
            self.hideActivityFromWindow()
            
            if error == nil
            {
               if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                {
                    let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                    let alertView = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
                    
                    alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            break
                        case .cancel:
                            break
                        case .destructive:
                            
                            break
                        }
                    }))
                    self.present(alertView, animated: true)
                }
                else
                {
                    self.onShowAlertController(title: kError , message: responseData?.valueForNullableKey(key: kMessage))
                }
            }
            else
            {
                self.onShowAlertController(title: kError , message: "Having some issue.Please try again.")
            }
        }
    }
    
    
    //MARK:- OrderPlace API Integration.............
    
    func OrderPlaceParameters(tokenId : String) -> NSMutableDictionary
    {
        var userDict = NSMutableDictionary()
        userDict = dictOrder
        userDict.setObject(tokenId, forKey: kPaymentToken as NSCopying)
        return userDict
    }
    
    
    @objc func methodPlaceOrderApi(tokenId:String)
    {
        getallApiResultwithPostTokenMethod(Details: OrderPlaceParameters(tokenId: tokenId), strMethodname: kMethodAddOrder) { (responseData, error) in
            
            self.hideActivityFromWindow()
            
            if error == nil
            {
               if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                {
                    let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                    let strOrderId = data.valueForNullableKey(key: kOrderId)
                    let alertView = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
                    
                    alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            
                            let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaceVC") as! OrderPlaceVC
                            NavCtrl.strOrderID = strOrderId
                            self.navigationController?.pushViewController(NavCtrl, animated: true)
                            
//                            let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "OrderCartVC") as! OrderCartVC
//                            NavCtrl.isNavigation = "Payment"
//                             NavCtrl.strOrderId = strOrderId
//                            self.navigationController?.pushViewController(NavCtrl, animated: true)
                            
                            break
                        case .cancel:
                            break
                        case .destructive:
                            
                            break
                        }
                    }))
                    self.present(alertView, animated: true)
                }
                else
                {
                    self.onShowAlertController(title: kError , message: responseData?.valueForNullableKey(key: kMessage))
                }
            }
            else
            {
                self.onShowAlertController(title: kError , message: "Having some issue.Please try again.")
            }
        }
    }
}

