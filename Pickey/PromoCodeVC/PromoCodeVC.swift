//
//  PromoCodeVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 27/01/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

// protocol used for sending data back
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: NSDictionary)
     func isNavigation(info: String)
}

class PromoCodeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var arrPromoCode = NSArray()
    var strAmount = ""
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblView.register(UINib(nibName: "PromoCodeTblCell", bundle: nil), forCellReuseIdentifier: "PromoCodeTblCell")
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.getPromocodeList), with: nil)
        }
        else
        {
            self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Promo Code", leftbuttonImageName: "back", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodBackBtnAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- UIButton Actions.........
    @objc func methodBackBtnAction(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func methodApplyPromoCode(_ sender: UIButton!)
    {
        let dictData = arrPromoCode[sender.tag] as! NSDictionary
        let id = dictData.valueForNullableKey(key: kCouponCode)
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.ApplyCodeApi(strid:)), with: id)
        }
        else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    //MARK:- tableView Delegate and DataSource......................
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrPromoCode.count>0{
            return arrPromoCode.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeTblCell") as! PromoCodeTblCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if arrPromoCode.count>0
        {
             let dictData = arrPromoCode[indexPath.row] as! NSDictionary
            
            cell.lblPromoCode.text = "DISCOUNT CODE : " + "\(dictData.valueForNullableKey(key: kCouponCode))"
            cell.lblPromoCodeDescription.text = dictData.valueForNullableKey(key: KitchenDescrition)
        }
        cell.btnApplyCode.tag = indexPath.row
        cell.btnApplyCode.addTarget(self, action: #selector(methodApplyPromoCode(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - ApplyPromoCode API Intigartion...................
    
    func AddWalletParameters(tokenId : String) -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        
        dict.setObject(tokenId, forKey: kPromoCode as NSCopying)
        dict.setObject(strAmount, forKey: kAmount as NSCopying)
        return dict
    }
    
    @objc func ApplyCodeApi(strid: String)
    {
        getallApiResultwithPostTokenMethod(Details: AddWalletParameters(tokenId: strid), strMethodname: kMethodApplyPromocode) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        
                        self.delegate?.isNavigation(info: "PromoCodeVC")
                        // call this method on whichever class implements our delegate protocol
                        self.delegate?.userDidEnterInformation(info: data)
                        // go back to the previous view controller
                        self.navigationController?.popViewController(animated: true)
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
    
    // MARK:- getPromocodeList API Integration.................
    @objc func getPromocodeList()
    {
        getallApiResultwithPostTokenMethod(Details: NSDictionary(), strMethodname: kMethodGetPromocode) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        if responseData?.object(forKey: kResponseDataDict) as? NSArray != nil
                        {
                            self.arrPromoCode = responseData?.object(forKey: kResponseDataDict) as! NSArray
                                 
                            self.tblView.reloadData()
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







