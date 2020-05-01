//
//  ProfileVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Outlets and Variables/Objects..............
    @IBOutlet weak var ConstraintToBarImg: NSLayoutConstraint!
    @IBOutlet weak var ViewProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var ConstaintScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var btnCoverPicture: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnChangePassword: ShadowButton!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    var imgProfileData = Data()
    var imgCoverData = Data()
    var isSelected = ""
    var strbtnType = ""
    
    //MARK:- System Defined Methods............
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        strbtnType = "edit"
        btnEditProfile.setImage(UIImage.init(named: "edit-1"), for: .normal)
        ViewProfile.layer.cornerRadius = ViewProfile.frame.height/2
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        self.blurEffect(Image: imgCover)
        
        self.txtEmail.isUserInteractionEnabled = false
        self.txtMobileNo.isUserInteractionEnabled = false
        self.txtName.isUserInteractionEnabled = false
        self.txtLastName.isUserInteractionEnabled = false
        addInputAccessoryForTextFields(textFields: [txtEmail, txtMobileNo], dismissable: true, previousNextable: true)
        
        if ScreenSize.SCREEN_HEIGHT >= 812
        {
            ConstaintScrollViewTop.constant = -44
        }
        else
        {
            ConstaintScrollViewTop.constant = -20
        }
        
        //loadProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        loadProfileData()
    }
    
    //MARK:- UIButton Actions..............
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func btnEditProfile(_ sender: UIButton)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func btnAddress(_ sender: UIButton)
    {
        
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
                                    let addrss = userLocation.valueForNullableKey(key: kAddress)
                                    self.lblAddress.text = addrss
                                    
                                }
                                if UserData.count>0
                                {
                                    //                                    if UserData.value(forKey: kFirstName) != nil && UserData.value(forKey: kFirstName) as! String != ""
                                    //                                    {
                                    self.txtName.text = (UserData.value(forKey: kFirstName) as! String)
                                    self.txtLastName.text = (UserData.value(forKey: kLastName) as! String)
                                    self.txtMobileNo.text = (UserData.value(forKey: kCountryCode) as! String) + (UserData.value(forKey: kMobileNumber) as! String)
                                    self.txtEmail.text = (UserData.value(forKey: kEmail) as! String)
                                    
                                    self.imgProfile.sd_addActivityIndicator()
                                    let url = URL.init(string: UserData.value(forKey: kProfilePicture) as! String)
                                    
                                    self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                                        self.imgProfile.sd_removeActivityIndicator()
                                    })
                                    
                                    self.imgCover.sd_addActivityIndicator()
                                    let url1 = URL.init(string: UserData.value(forKey: kBannerImage) as! String)
                                    
                                    self.imgCover.sd_setImage(with: url1, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                                        self.imgCover.sd_removeActivityIndicator()
                                    })
                                    // }
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
