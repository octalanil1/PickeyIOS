//
//  SidePanelVC.swift
//  PepperCorn
//
//  Created by sunil-ios on 7/13/18.
//  Copyright © 2018 NInehertz013. All rights reserved.
//

import UIKit
import SDWebImage

class SidePanelVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet var tblVW: UITableView!
    
    //MARK:- Variables
    var arrTitle = ["Kitchen List", "My Orders", "My Profile", "Wallet", "Invite Friends", "Rate & Review", "Notifications", "More"]  //,"Meals"
    var arrImg = ["more", "My_orders", "my_profile", "wallet", "invite_friends", "rate_review", "notification", "more"]  //,"meal"
    var strImgUrl = ""
    var strName  = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblVW.register(UINib(nibName: "SidePanelTblCell", bundle: nil), forCellReuseIdentifier: "SidePanelTblCell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if #available(iOS 11.0, *){
            tblVW.contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //Notificarion Get From Edit Profile Screen
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: Notification.Name("updateData"), object: nil)
        
        if isNavigationFrom != "isFromWelcomeVC" && isNavigationFrom != "isFromSkipNow"
        {
            loadProfileData()
        }
    }
    
    @objc func updateData(notification: NSNotification)
    {
        loadProfileData()
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
    
    @objc func MethodLogout(_ sender: UIButton)
    {
        if isNavigationFrom != "isFromWelcomeVC" && isNavigationFrom != "isFromSkipNow"
        {
            let alertView = UIAlertController(title: "Are you sure you want to Logout?", message: "", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                case .default:
                    
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.windowShowActivity(text: "")
                        self.performSelector(inBackground: #selector(self.userLogout), with: nil)
                        
                    } else
                    {
                        self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                    }
                    break
                case .cancel:
                    break
                case .destructive:
                    
                    break
                }
            }))
            alertView.addAction(UIAlertAction(title: "No", style: .cancel) { action in
                print("Action: DFU resumed")
            })
            present(alertView, animated: true)
        }
        else
        {
            self.appDelegate.showFirstPage()
            isNavigationFrom = ""
        }
    }
    
    @objc func MethodSwitchType(_ sender:UIButton)
    {
        if appDelegate.SwitchType == "Adult"
        {
            appDelegate.SwitchType = "Chlid"
        }
        else
        {
            appDelegate.SwitchType = "Adult"
        }
        tblVW.reloadData()
        
        self.appDelegate.showtabbar()
    }
    
    //MARK:- Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1
        {
            return arrTitle.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let indentifier:String = "HeaderTblCell"
            var cell : HeaderTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? HeaderTblCell
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("HeaderTblCell", owner: nil, options: nil)! as [Any]
                cell = nib[0] as? HeaderTblCell
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                cell?.backgroundColor = (UIColor.clear)
            }
            
            cell?.imgProfile.sd_addActivityIndicator()
            let url = URL.init(string: strImgUrl)
            cell?.imgProfile.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell?.imgProfile.sd_removeActivityIndicator()
            })
            cell?.lblName.text = strName //self.appDelegate.currentLoginUser.fullNameString
            
            return cell!
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SidePanelTblCell") as! SidePanelTblCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = (UIColor.clear)
            
            cell.lblTitle.text = arrTitle[indexPath.row]
            cell.imgVW.image = UIImage(named: arrImg[indexPath.row])
            
            return cell
        }
        else
        {
            let indentifier:String = "FooterTblCell"
            var cell : FooterTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? FooterTblCell
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("FooterTblCell", owner: nil, options: nil)! as [Any]
                cell = nib[0] as? FooterTblCell
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                cell?.backgroundColor = (UIColor.clear)
                cell?.btnSwitchAdults.tag = indexPath.row
                cell?.btnSwitchAdults.addTarget(self, action: #selector(MethodSwitchType(_ :)), for: .touchUpInside)
                if self.appDelegate.SwitchType == "Adult"
                {
                    cell?.btnSwitchAdults.setTitle("Switch to Childs", for: .normal)
                }
                else
                {
                    cell?.btnSwitchAdults.setTitle("Switch to Adults", for: .normal)
                }
                
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    cell?.lblLogOut.text = "LOGIN"
                }
                else
                {
                    cell?.lblLogOut.text = "LOGOUT"
                }
                cell?.btnlogOut.addTarget(self, action: #selector(MethodLogout(_:)), for: .touchUpInside)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
            {
                let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                }
                alert.addAction(actionAllow)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
            }
        }
        else if indexPath.section == 1
        {
            switch indexPath.row
            {
            case 0:
                
                self.appDelegate.showtabbar()
                break
            case 1:
               
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController:
                    self.storyboard!.instantiateViewController(withIdentifier: "OrderDetailVC")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
               
                break
                
            case 2:
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
                
                break
                
            case 3:
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "WalletVC")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
               
                break
                
            case 4:
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
               
                break
                
            case 5:
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "RateAndReview")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
                
                break
                
            case 6:
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController:
                        self.storyboard!.instantiateViewController(withIdentifier: "NotificationsVC")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
                
                break
                
            case 7:
                if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
                {
                    let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                    let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    }
                    alert.addAction(actionAllow)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController:
                        self.storyboard!.instantiateViewController(withIdentifier: "MoreVC")), animated: true)
                    self.sideMenuViewController!.hideMenuViewController()
                }
                
                break
                
            default:
                break
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 120
        }
        else if indexPath.section == 1
        {
            return 50
        }
        else
        {
            return 157
        }
    }
    
    // MARK:- Logout API Integration
    func logoutParameter() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        var StrToken = "simulator"
        if UserDefaults.standard.object(forKey: kDeviceToken) != nil {
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        dictUser.setObject(StrToken, forKey: kDeviceToken as NSCopying)
        dictUser.setObject(kDeviceName, forKey: kDeviceType as NSCopying)
        return dictUser
    }
    
    @objc func userLogout()
    {
        getallApiResultwithPostTokenMethod(Details: self.logoutParameter(), strMethodname: kMethodLogOut) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.appDelegate.clearData()
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
    
    // MARK:- getProfile API Integration
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
                                if UserData.count>0
                                {
                                    if UserData.value(forKey: kFirstName) != nil && UserData.value(forKey: kFirstName) as! String != ""
                                    {
                                        self.strName = ("\(String(describing: UserData.value(forKey: kFirstName)!))" + " " + "\(String(describing: UserData.value(forKey: kLastName)!))")
                                        self.strImgUrl = UserData.value(forKey: kProfilePicture) as! String
                                    }
                                    self.tblVW.reloadData()
                                }
                            }
                            if (responseData?.object(forKey: "data") as! NSDictionary).object(forKey: "UserLocation") != nil
                            {
                                let UserLocationData = (responseData?.object(forKey: "data") as! NSDictionary).object(forKey: "UserLocation") as! NSDictionary
                                if UserLocationData.count>0
                                {
                                    StrCurrentaddress = UserLocationData.valueForNullableKey(key: kAddress)
                                }
                            }
                        }
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == ktokenExpire)
                    {
//                        let alert = UIAlertController(title: "", message:responseData?.object(forKey: kMessage) as? String , preferredStyle: .alert)
//
//                        let actionAllow = UIAlertAction(title: "OK", style: .default) { alert in
//
//                            self.appDelegate.clearData()
//                        }
//                        alert.addAction(actionAllow)
//                        self.present(alert, animated: true, completion: nil)
                        
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
                        self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: kMessage)! as! String?)
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.")
                }
            }
        }
    }
    
    //MARK:- Memory Methods
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
