//
//  ManageAccountVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class ManageAccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlets and Variables/Objects..............
    @IBOutlet weak var tblManage:UITableView!
    var arrAddressData = NSMutableArray()
    var SelectRemoveaddressId = ""
    var isNavigation = ""
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate? = nil
    
    //MARK:- System Defined Methods............
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        GetLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- UIButton Actions..............
    @IBAction func btnBack(_ sender: UIButton)
    {
        if isNavigation == "KitchenList"
        {
            self.appDelegate.showtabbar()
        }
        else
        {
          self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func AddNewAdderss(_ sender:UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        vc.isNavigation = "AddAddress"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func UpdateAddress(_ sender:UIButton)
    {
        let data = self.arrAddressData.object(at: sender.tag) as! NSDictionary
        let addressId = String(format: "%@", arguments:[data.object(forKey: "id") as! CVarArg])
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        vc.isNavigation = "UpdateAddress"
        vc.AddressDataStore = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func DeletAddress(_ sender:UIButton)
    {
        let data = self.arrAddressData.object(at: sender.tag) as! NSDictionary
        SelectRemoveaddressId = String(format: "%@", arguments:[data.object(forKey: "id") as! CVarArg])
        self.DeleteAddress()
    }
    
    //MARK:- tableView Delegate and Datasource..............
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return self.arrAddressData.count
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManageTblCell") as! ManageTblCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = (UIColor.clear)
            let datadict = self.arrAddressData.object(at: indexPath.row) as! NSDictionary
            cell.lblTitle.text = datadict.object(forKey: kAddressType) as! String
           
            //cell.lblAddress.text = "\(datadict.object(forKey: kFlatNumber) as! String)" + ", " + "\(datadict.object(forKey: kAddress) as! String)"
           cell.lblAddress.text = datadict.object(forKey: kAddress) as! String
            
            let isdefault = datadict.object(forKey: "is_default") as! String
            
            if isdefault == "Yes"
            {
                cell.btnTickRight.isHidden = false
            }
            else
            {
                cell.btnTickRight.isHidden = true
            }
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(UpdateAddress(_:)), for: .touchUpInside)
            cell.btnClose.tag = indexPath.row
            cell.btnClose.addTarget(self, action: #selector(DeletAddress(_:)), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewAddressCell") as! AddNewAddressCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = (UIColor.clear)
            cell.btnAddress.addTarget(self, action: #selector(AddNewAdderss(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManageTblCell") as! ManageTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            let data = self.arrAddressData.object(at: indexPath.row) as! NSDictionary
            SelectRemoveaddressId = String(format: "%@", arguments:[data.object(forKey: "id") as! CVarArg])
            if self.appDelegate.isInternetAvailable() == true
            {
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.DefaultAddressMethodApi), with: nil)
                
            } else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: GetLocation API Implementation..................
    func GetLocation()
    {
        getallApiResultwithPostTokenMethod(Details: [:], strMethodname: kMethodGetLocation) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.arrAddressData = (responseData?.object(forKey: kResponseDataDict) as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0..<self.arrAddressData.count
                        {
                            let addrdata = self.arrAddressData.object(at: i) as! NSDictionary
                            let isdefaulttype = addrdata.object(forKey: "is_default") as! String
                            if isdefaulttype == "Yes"
                            {
                                let lat = String(format: "%@", arguments: [addrdata.object(forKey: "latitude") as! CVarArg])
                                Strlat = Double(lat)!
                                let longt = String(format: "%@", arguments: [addrdata.object(forKey: "longitude") as! CVarArg])
                                Strlong = Double(longt)!
                                StrAddressID  = String(format: "%@", arguments: [addrdata.object(forKey: "id") as! CVarArg])
                                StrAddresstype = String(format: "%@", arguments: [addrdata.object(forKey: "address_type") as! CVarArg])
                                StraddressString = String(format: "%@", arguments: [addrdata.object(forKey: "address") as! CVarArg])
                                StrLandMark = String(format: "%@", arguments: [addrdata.object(forKey: "flat_number") as! CVarArg])
                            }
                        }
                        self.tblManage.reloadData()
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
    
    
     //MARK:- Delete API Imlementation.................
    func DeleteAddress()
    {
        self.view.endEditing(true)
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.DeleteAddressMethodApi), with: nil)
            
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    func DeleteDefaultParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(SelectRemoveaddressId, forKey: kAddressId as NSCopying)
        return dict
    }
    
    @objc func DeleteAddressMethodApi()
    {
        getallApiResultwithPostTokenMethod(Details:DeleteDefaultParam(), strMethodname: kMethodDeleteLocation) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.GetLocation()
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
    
    //MARK: DefaultLocation API Implementation................
    @objc func DefaultAddressMethodApi()
    {
        getallApiResultwithPostTokenMethod(Details:DeleteDefaultParam(), strMethodname: kMethodDefaultLocation) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.GetLocation()
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
