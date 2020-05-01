//
//  AccountVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class AccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    var arrTitle = ["Manage Address", "Payment Method", "Reward / Loyalty Program", "Region & Languages", "Notification Settings", "Edit Profile", "Change Password"]
    
    var arrImages = [UIImage.init(named: "manage_address"), UIImage.init(named: "manage_payment"), UIImage.init(named: "rewards"), UIImage.init(named: "language"), UIImage.init(named: "notification"), UIImage.init(named: "edit_profile"), UIImage.init(named: "change_password")]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Account", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //MARK:- UIButton Actions.........
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @objc func methodAddCart(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setNotificationOnOff(btn:UISwitch)
    {
        var isNotification = 0
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            
            if  self.NotificaionCheck() == false
            {
                self.appDelegate.NotificaionPermissionCheck()
            }
            isNotification = 0
            btn.isOn = false
        }else {
            isNotification = 1
            btn.isOn = true
        }
        if self.appDelegate.isInternetAvailable() == true
        {
            let dictUser = NSMutableDictionary()
            dictUser.setObject(isNotification, forKey: kMethodNotifyOnOff as NSCopying)
            
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodNotificationONOffApi(_:)), with: dictUser)
        }
        else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTblCell") as! AccountTblCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = (UIColor.clear)
        
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.imgTitle.image = arrImages[indexPath.row]
        if indexPath.row == 4
        {
            cell.btnRight.isHidden = true
            cell.Switch.isHidden = false
            cell.Switch.addTarget(self, action: #selector(setNotificationOnOff(btn:)), for: .touchUpInside)
             
             if  self.appDelegate.currentLoginUser.strNotiOnOff == "1"
             {
                 if self.NotificaionCheck() == true
                 {
                     //cell.Switch.setImage(UIImage(named: "unactive"), for: .normal)
                    cell.Switch.isOn = true
                 }
                 else
                 {
                     //cell.Switch.setImage(UIImage(named: "active"), for: .normal)
                     cell.Switch.isOn = false
                 }
             }
             else
             {
                 cell.Switch.isOn = false
             }
        }
        else
        {
           cell.btnRight.isHidden = false
           cell.Switch.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageAccountVC") as! ManageAccountVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2
        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3
        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 4
        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func NotificaionCheck()-> Bool
    {
        var isNotification = false
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            isNotification = true
            print("APNS-YES")
        }
        return isNotification
    }
    
    //MARK:- API Like&Unlike Methods
    @objc func methodNotificationONOffApi(_ dicNotify:NSMutableDictionary)
    {
        getallApiResultwithPostTokenMethod(Details: dicNotify, strMethodname: kMethodNotifyOnOff) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.appDelegate.saveCurrentUser(currentUserdict: responseData?.object(forKey: kResponseDataDict) as! NSDictionary)
                        self.appDelegate.currentLoginUser = self.appDelegate.getLoginUser()
                        
                        self.tblView.reloadData()
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
}
