//
//  EditProfileVC.swift
//  Pickey
//
//  Created by octal on 27/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //MARK:- Outlets and Variables/Objects..............
    @IBOutlet weak var ViewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCoverPicture: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnChangePassword: ShadowButton!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDob:UITextField!
    @IBOutlet weak var btnMale:UIButton!
    @IBOutlet weak var btnFeMale:UIButton!
    @IBOutlet weak var lblAddress:UILabel!
    //MARK:-Datepicker
    var datePicker = UIDatePicker()
    
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    var imgProfileData = Data()
    var imgCoverData = Data()
    var isSelected = ""
    var strbtnType = ""
    var strGenderType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        strbtnType = "save"
        ViewProfile.layer.cornerRadius = ViewProfile.frame.height/2
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        self.blurEffect(Image: imgCover)
        
        txtFirstName.layer.cornerRadius = 5
        txtFirstName.layer.borderColor = UIColor.init(red: 229/255, green: 230/255, blue: 231/255, alpha: 1).cgColor
        txtFirstName.layer.borderWidth = 1
        txtFirstName.setLeftPaddingPoints(10)
        
        txtLastName.layer.cornerRadius = 5
        txtLastName.layer.borderColor = UIColor.init(red: 229/255, green: 230/255, blue: 231/255, alpha: 1).cgColor
        txtLastName.layer.borderWidth = 1
        txtLastName.setLeftPaddingPoints(10)

        addInputAccessoryForTextFields(textFields: [txtEmail, txtMobileNo,txtLastName,txtFirstName,txtDob], dismissable: true, previousNextable: true)
        loadProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.lblAddress.text = StrLandMark + ", " + StraddressString
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDob
        {
            showDatePicker()
        }
    }
    
    //MARK:- DatePicker
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
       
        //Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDob.inputAccessoryView = toolbar
        txtDob.inputView = datePicker
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" //"dd/MM/yyyy"
        txtDob.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    //MARK:- Select Gender
    @IBAction func btnMale(_ sender:UIButton) {
        
            strGenderType = "1"
            btnFeMale.backgroundColor = UIColor.white
            btnMale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
    }
    @IBAction func btnFemale(_ sender: UIButton) {
        
            strGenderType = "0"
            btnMale.backgroundColor = UIColor.white
            btnFeMale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
    }
    
    //MARK:- UIButton Actions..............
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
       // self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        //self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func btnChangeProfilePic(_ sender: UIButton)
    {
        if strbtnType == "save"
        {
            isSelected = "Profile"
            ShowMedia()
        }
    }
    
    @IBAction func btnCoverPicture(_ sender: UIButton)
    {
        if strbtnType == "save"
        {
            isSelected = "Cover"
            ShowMedia()
        }
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:-GetLocation
    @IBAction func btnAddress(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        vc.isNavigation = "editprofile"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Helper Method
    func loadProfileData()
    {
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            
            self.performSelector(inBackground: #selector(self.getProfile), with: nil)
        }
        else
        {
            self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
        }
    }
    
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Camera Permission Method.........
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            checkCameraPermission { (permission) in
                if (permission){
                    self.imagePicker!.sourceType = UIImagePickerController.SourceType.camera
                    self.imagePicker?.allowsEditing = true
                    self.imagePicker?.delegate = self
                    self .present(self.imagePicker!, animated: true, completion: nil)
                }
            }
        }
    }
    
    func openGallary()
    {
        checkGalleryPermission { (permission) in
            if (permission){
                self.imagePicker!.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.imagePicker!.allowsEditing = true
                self.imagePicker!.delegate = self
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }
    }
    
    func ShowMedia()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openGallary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK:- ImagePicker Delegate............
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        
        if isSelected == "Profile"
        {
            self.blurEffect(Image: imgCover)
            imgProfile.image = selectedImage
            self.imgProfileData = selectedImage.jpegData(compressionQuality: 0.75)!  //0.6
        }
        else
        {
            imgCover.image = selectedImage
            self.blurEffect(Image: imgCover)
            self.imgCoverData = selectedImage.jpegData(compressionQuality: 0.75)!  //0.6
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnEditProfile(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.checkValidation()
        {
        if strbtnType == "save"
        {
            if appDelegate.isInternetAvailable() == true
            {
                self.showActivity(text: "")
                self.performSelector(inBackground: #selector(self.updateUserProfile), with: nil)
            }
            else
            {
                self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
            }
        }
        }
    }

    //MARK:- UItextFeild Validation Method...........
    func checkValidation() -> Bool
    {
        if self.txtDob.text == ""
        {
            onShowAlertController(title: kError, message: emptyDOB)
            return false
        }
        else if txtFirstName.text == ""
        {
            onShowAlertController(title: kError, message: emptyFirstNameError)
            return false
        }
        else if txtLastName.text == ""
        {
            onShowAlertController(title: kError, message: emptyLastNameError)
            return false
        }
        else if txtMobileNo.text == ""
        {
            onShowAlertController(title: kError, message: emptyMobileNoError)
            return false
        }
        else if txtEmail.text == ""
        {
            onShowAlertController(title: kError, message: emptyEmailAddressError)
            return false
        }
        else if (self.txtLastName.text?.count)! < 3
        {
            onShowAlertController(title: kError, message: validLastNameError)
            return false
        }
        else if (txtMobileNo.text?.count)! < 7
        {
            onShowAlertController(title: kError , message: validMobile)
            return false
        }
        else if self.isValidEmail(testStr: txtEmail.text!) == false
        {
            onShowAlertController(title: kError, message: validEmail)
            return false
        }
        else if lblAddress.text == ""
        {
            onShowAlertController(title: kError, message: emptyAddressError)
            return false
        }
        return true
    }
    
    //MARK:- API Integration
    func updateProfileParametes() -> NSMutableDictionary
    {
        let userDict = NSMutableDictionary()
        
        userDict.setObject(txtFirstName.text!, forKey: kFirstName as NSCopying)
        userDict.setObject(txtLastName.text!, forKey: kLastName as NSCopying)
        userDict.setObject(StrLandMark + ", " + StraddressString, forKey: kAddress as NSCopying)
        userDict.setObject(StrAddressID, forKey: kAddressId as NSCopying)
        userDict.setObject(StrAddresstype, forKey: kAddressType as NSCopying)
        let strlatitude:String = String(Strlat)
        let strlongtitude:String = String(Strlong)
        userDict.setObject(strlatitude, forKey: kLatitude as NSCopying)
        userDict.setObject(strlongtitude, forKey: kLongititude as NSCopying)
        userDict.setObject(strGenderType, forKey: kGender as NSCopying)
        userDict.setObject(txtDob.text!, forKey:kDob as NSCopying)
        return userDict
    }
    
    //MARK: updateUserProfile Api..............
    @objc func updateUserProfile()
    {
        getallApiResultwithimagePostMethod(strMethodname: kMethodEditProfile, userimageData: imgProfileData, userbannerData: imgCoverData, struserimageKey: kProfilePicture, struserbannerKey: kBannerImage, Details: updateProfileParametes()) { (responseData, error) in
            
            self.hideActivity()
            
            if error == nil
            {
                if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                {
                  
                    self.appDelegate.saveCurrentUser(currentUserdict: responseData?.object(forKey: kResponseDataDict) as! NSDictionary)
                    UserDefaults.standard.set("Yes", forKey: kLoginCheck)
                    self.appDelegate.currentLoginUser = self.appDelegate.getLoginUser()
                    
                    NotificationCenter.default.post(name: Notification.Name("updateData"), object: nil)
                    
                    let alertVC = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertVC.addAction(alertAction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
                else if responseData?.valueForNullableKey(key: kResponseDataStatus) == kDeActive
                {
                    let alertVC = UIAlertController(title: "", message: "Your account is deactivated by admin team for review. Please contact to support team.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                        
                        self.appDelegate.clearData()
                    })
                    alertVC.addAction(alertAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                else if responseData?.valueForNullableKey(key: kResponseDataStatus) == kUnauthenticated
                {
                    let alertVC = UIAlertController(title: "", message: "Your sesssion has been expired. Please login again.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                        
                        self.appDelegate.clearData()
                    })
                    alertVC.addAction(alertAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            else
            {
                self.onShowAlertController(title: kError , message: "Having some issue.Please try again.")
            }
        }
    }
    
    //MARK: GetUserProfile Api..............
    @objc func getProfile()
    {
        getallApiResultwithPostTokenMethod(Details: NSDictionary(), strMethodname: kMethodGetProfile) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        if responseData?.object(forKey: kResponseDataDict) as? NSDictionary != nil
                        {
                            if (responseData?.object(forKey: "data") as! NSDictionary).object(forKey: "User") != nil
                            {
                                let UserData = (responseData?.object(forKey: "data") as! NSDictionary).object(forKey: "User") as! NSDictionary
                                let userLocation = (responseData?.object(forKey: "data") as! NSDictionary).object(forKey: "UserLocation") as! NSDictionary
                                //Mark:- userLocation
                                if userLocation.count != 0
                                {
                                    StrAddresstype = userLocation.valueForNullableKey(key: kAddressType)
                                    StrAddressID =  userLocation.valueForNullableKey(key: "id")
                                    let addrss = userLocation.valueForNullableKey(key: kAddress)
                                    self.lblAddress.text = addrss
                                    StraddressString = addrss
                                    
                                    let housenumberarr = addrss.components(separatedBy: ",")
                                    if housenumberarr.count == 1
                                    {
                                        let houseno = housenumberarr[0]
                                        StrHouseNumber = houseno
                                    }
                                    else{
                                        let houseno = housenumberarr[0] + housenumberarr[1]
                                        StrHouseNumber = houseno
                                    }
                                    let strlatitude = userLocation.valueForNullableKey(key: kLatitude)
                                    Strlat = Double(strlatitude) as! Double
                                    let strlongti = userLocation.valueForNullableKey(key: kLongititude)
                                    Strlong = Double(strlongti) as! Double
                                }
                                //Mark:- userdata
                                if UserData.count>0
                                {
                                    self.txtFirstName.text = UserData.valueForNullableKey(key: kFirstName)
                                    self.txtLastName.text = UserData.valueForNullableKey(key: kLastName)
                                    self.txtMobileNo.text = UserData.valueForNullableKey(key: kCountryCode) + UserData.valueForNullableKey(key: kMobileNumber)
                                    self.txtEmail.text = UserData.valueForNullableKey(key: kEmail)
                                    self.txtDob.text = UserData.valueForNullableKey(key: kDob)
                                    
                                    
                                    self.strGenderType =  UserData.valueForNullableKey(key: kGender)
                                    if self.strGenderType == "1"
                                    {
                                        self.btnFeMale.backgroundColor = UIColor.white
                                        self.btnMale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
                                    }
                                    else
                                    {
                                        self.btnMale.backgroundColor = UIColor.white
                                        self.btnFeMale.backgroundColor = UIColor.init(red: 233/255, green: 75/255, blue: 0/255, alpha: 1)
                                    }
                                    self.imgProfile.sd_addActivityIndicator()
                                    let url = URL.init(string: UserData.value(forKey: kProfilePicture) as! String)
                                    
                                    self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                                        self.imgProfile.sd_removeActivityIndicator()
                                    })
                                    
                                    self.imgCover.sd_addActivityIndicator()
                                    let url1 = URL.init(string: UserData.value(forKey: kBannerImage) as! String)
                                    
                                    self.imgCover.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "logo.jpg"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                                        self.imgCover.sd_removeActivityIndicator()
                                    })
                                    
                                }
                            }
                        }
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
                        self.onShowAlertController(title: kError , message: responseData?.object(forKey: kMessage)! as! String?)
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: kError , message: "Having some issue.Please try again.")
                }
            }
            
        }
    }
}
