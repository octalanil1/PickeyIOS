//
//  SignUpVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 15/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import CountryPickerView

class SignUpVC: UIViewController, UITextFieldDelegate {

    //MARK:- Outlets and Variables/Objects..............
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBreakfastTo: UITextField!
    @IBOutlet weak var txtBreakfastFrom: UITextField!
    @IBOutlet weak var txtSelectType:UITextField!
    @IBOutlet weak var txtDelivery: UITextView!
    @IBOutlet weak var tbldata:UITableView!
    @IBOutlet weak var imgFlag: UIImageView!
    
    @IBOutlet weak var btnMale:UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    var isNavigation = ""
    let cpvInternal = CountryPickerView()
    var Timearr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    var SelectNo:Int = 0
    var strGenderType = ""
    
    var arrSelectedSortData = NSMutableArray()
    
    
    //MARK:- System Defined Methods............
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        [cpvInternal].forEach {
            $0.dataSource = self
        }
         cpvInternal.delegate = self
         getCountryCode()
        addInputAccessoryForTextFields(textFields: [txtName, txtSurname, txtCountryCode, txtEmailAddress, txtMobileNumber, txtPassword], dismissable: true, previousNextable: true)
        addInputAccessoryForTextView(textViews: [txtDelivery], dismissable: true, previousNextable: true)
        txtBreakfastFrom.toStyledTextField()
        txtBreakfastTo.toStyledTextField()
        txtDelivery.layer.cornerRadius = 5
        txtDelivery.clipsToBounds = true
        txtDelivery.layer.borderColor = UIColor.init(red: 229/255, green: 230/255, blue: 231/255, alpha: 1.0).cgColor
        txtDelivery.layer.borderWidth = 1
        tbldata.layer.borderWidth = 0.5
        tbldata.layer.borderColor = UIColor.lightGray.cgColor
        arrSelectedSortData.add("Breakfast")
        //txtCountryCode.text = "971"
        strGenderType = "1"
        btnFemale.backgroundColor = UIColor.white
        btnMale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCountryCode
        {
           return false
        }
        return true
    }
    
    //MARK:- UIButton Actions..............
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: UIButton)
    {
         self.view.endEditing(true)
        if self.checkValidation()
        {
            var intFromTime = Int(txtBreakfastFrom.text!)
            var intToTime = Int(txtBreakfastTo.text!)
            
            if intFromTime! > intToTime!
            {
                onShowAlertController(title: kError, message: ValidationLarger)
            }
            else
            {
                if self.appDelegate.isInternetAvailable() == true
                {
                    self.windowShowActivity(text: "")
                    self.performSelector(inBackground: #selector(self.methodSignupApi), with: nil)
                    
                } else
                {
                    self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                }
            }
            
        }
    }
    
    @IBAction func btnCountryPicker(_ sender: UIButton)
    {
        if let nav = navigationController {
            nav.isNavigationBarHidden = true
            cpvInternal.showCountriesList(from: nav)
        }
    }
    
    func getCountryCode()
    {
        let locale = Locale.current
        guard let countriesArray = cpvInternal.countries as [Country]? else {return}
        let foundItems = countriesArray.filter { $0.code == "\(locale.regionCode ?? "")"}
        txtCountryCode.text = "\((foundItems.first)!.phoneCode)"
        imgFlag.image = (foundItems.first)!.flag
    }
    
    @IBAction func btnlogin(_ sender: UIButton)
    {
        if isNavigation == "SignUpVC"
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
        
    @IBAction func OpenDropDown(_ sender: UIButton)
    {
        let menuVC  = self.storyboard!.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
        
        self.addChild(menuVC)
        self.view.addSubview(menuVC.view)
        
        menuVC.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
        
    }
    @IBAction func Selectchk(_ sender:UIButton)
    {
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func DoneAction(_ sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Select Gender
    @IBAction func btnMale(_ sender:UIButton) {
        
            strGenderType = "1"
            btnFemale.backgroundColor = UIColor.white
            btnMale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
    }
    @IBAction func btnFemale(_ sender:UIButton) {
        
            strGenderType = "0"
            btnMale.backgroundColor = UIColor.white
            btnFemale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
    }
    
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtSelectType
        {
        
            let menuVC  = self.storyboard!.instantiateViewController(withIdentifier: "SelectTypeVC") as! SelectTypeVC
            
            self.addChild(menuVC)
            self.view.addSubview(menuVC.view)
            
            menuVC.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            }, completion:nil)
        }
        if textField == txtBreakfastFrom
        {
            self.view.endEditing(true)
            SelectNo = 1
            tbldata.isHidden = false
        }
        if textField == txtBreakfastTo
        {
            self.view.endEditing(true)
            SelectNo = 2
            tbldata.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        tbldata.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 5
        {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
extension SignUpVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Timearr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell") as! CalenderCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.lbl_time.text = Timearr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   //  let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell") as! CalenderCell
        let cell = tableView.cellForRow(at: indexPath) as! CalenderCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        self.view.endEditing(true)
        let p = Timearr[indexPath.row]
       
        if SelectNo == 1
        {
            txtBreakfastFrom.text = p
            tbldata.isHidden = true
        }
        if SelectNo == 2
        {
             txtBreakfastTo.text = p
            tbldata.isHidden = true
        }
    }
    @IBAction func btn_chkClick(_ sender:UIButton)
    {
        self.view.endEditing(true)
        if sender.tag == 10
        {
            if sender.isSelected
            {
                sender.isSelected = false
                arrSelectedSortData.remove("Breakfast")
                txtBreakfastTo.text = ""
                txtBreakfastFrom.text = ""
                txtBreakfastFrom.isUserInteractionEnabled = false
                txtBreakfastTo.isUserInteractionEnabled = false
                tbldata.isHidden = true
            }
            else
            {
                sender.isSelected = true
                arrSelectedSortData.add("Breakfast")
                txtBreakfastFrom.isUserInteractionEnabled = true
                txtBreakfastTo.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK:- UItextFeild Validation Method...........
    func checkValidation() -> Bool
    {
        if self.txtName.text == ""
        {
            onShowAlertController(title: kError, message: emptyFirstNameError)
            return false
        }
        else if (self.txtName.text?.count)! < 3
        {
            onShowAlertController(title: kError, message: validFirstNameError)
            return false
        }
        else if self.txtSurname.text == ""
        {
            onShowAlertController(title: kError, message: emptyLastNameError)
            return false
        }
        else if (self.txtSurname.text?.count)! < 3
        {
            onShowAlertController(title: kError, message: validLastNameError)
            return false
        }
        else if self.txtMobileNumber.text == ""
        {
            onShowAlertController(title: kError , message: emptyMobileNoError)
            return false
        }
        else if (txtMobileNumber.text?.count)! < 7
        {
            onShowAlertController(title: kError , message: validMobile)
            return false
        }
        else if self.txtEmailAddress.text == ""
        {
            onShowAlertController(title: kError, message: emptyEmailAddressError)
            return false
        }
        else if self.isValidEmail(testStr: txtEmailAddress.text!) == false
        {
            onShowAlertController(title: kError, message: validEmail)
            return false
        }
        else if txtPassword.text == ""
        {
            onShowAlertController(title: kError, message: emptyPasswordError)
            return false
        }
        else if txtPassword.text!.count < 7
        {
           onShowAlertController(title: kError, message: validPasswordError)
            return false
        }
        else if txtDelivery.text! == ""
        {
            onShowAlertController(title: kError, message: emptyDeliveryNote)
            return false
        }
        for (i,v) in arrSelectedSortData.enumerated()
        {
            
            if v as! String == "Breakfast"
            {
                if txtBreakfastFrom.text == ""
                {
                    onShowAlertController(title: kError, message: ValidBreakFastFromTime)
                    return false
                }
                else if txtBreakfastTo.text == ""
                {
                    onShowAlertController(title: kError, message: ValidBreakFastToTime)
                    return false
                }
            }
        }
        return true
    }
    
    //MARK: - Method Signup Api..........
    func SignupParameters() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(self.txtName.text!, forKey: kFirstName as NSCopying)
        dictUser.setObject(self.txtSurname.text!, forKey: kLastName as NSCopying)
        dictUser.setObject(self.txtEmailAddress.text!, forKey: kEmail as NSCopying)
        dictUser.setObject(self.txtPassword.text!, forKey: kPassword as NSCopying)
        dictUser.setObject(self.txtCountryCode.text!, forKey: kCountryCode as NSCopying)
        dictUser.setObject(self.txtMobileNumber.text!, forKey: kMobileNumber as NSCopying)
        dictUser.setObject(self.txtBreakfastFrom.text!, forKey: kTimeslotFrom as NSCopying)
        dictUser.setObject(self.txtBreakfastTo.text!, forKey: kTimeslotTo as NSCopying)
        dictUser.setObject(self.txtDelivery.text!, forKey: kDeliveryNote as NSCopying)
        dictUser.setObject(strGenderType, forKey: kGender as NSCopying)
        
        return dictUser
    }
    
    @objc func methodSignupApi()
    {
        getAllApiResults(Details: self.SignupParameters(), srtMethod: kMethodSignUp) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let RegisterData: NSDictionary = responseData?.value(forKey: kResponseDataDict) as! NSDictionary
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                        vc.strOtpCode = RegisterData.valueForNullableKey(key: kOtp)
                        vc.strTempID = RegisterData.valueForNullableKey(key: kTempId)
                        vc.DictRegisterParameter = self.SignupParameters()
                        vc.isNavigation = "signup"
                        self.navigationController?.pushViewController(vc, animated: true)
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //if touches.first?.view?.tag == 10{
            dismiss(animated: true, completion: nil)
            super.touchesEnded(touches , with: event)
       // }
    }
    
     func touchesBegan(_ touches: Set<AnyHashable>, withEvent event: UIEvent)
     {
        var touch: UITouch? = touches.first as! UITouch
       // if touch?.view != self.tbldata {
            self.tbldata.isHidden = true
      //  }
    }
}

extension SignUpVC: CountryPickerViewDataSource, CountryPickerViewDelegate {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.navigationController?.isNavigationBarHidden = true
        imgFlag.image = country.flag
        txtCountryCode.text = "\(country.phoneCode)"
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
