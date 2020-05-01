//
//  MealsVC.swift
//  Pickey
//p[kp-
//  Created by Sunil Pradhan on 20/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class MealsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FloatRatingViewDelegate {
    
    @IBOutlet weak var TblDeliver: UITableView!
    @IBOutlet weak var CollectionViewOutlet: UICollectionView!
    @IBOutlet weak var btnSelfPickUp: UIButton!
    @IBOutlet weak var btnDelivery: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    var dictKitchenDetails = NSDictionary()
    var arrKitchenMenu = NSArray()
    var data = NSDictionary()
    var strMealType = ""
    var strKitchenFarmID = ""
    var strKitchenName = ""
    
    //MARK:- System Defined Methods................
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: strKitchenName, leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            MealMethodApi()
            // self.performSelector(inBackground: #selector(self.MealMethodApi), with: nil)t
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- UIButton Actions.........
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDelivery(_ sender: UIButton)
    {
        btnSelfPickUp.setTitleColor(UIColor.init(red: 105/255.0, green: 105/255.0, blue: 106/255.0, alpha: 1.0), for: .normal)
        btnSelfPickUp.backgroundColor = UIColor.init(red: 236/255.0, green: 239/255.0, blue: 240/255.0, alpha: 1.0)
        
        btnDelivery.setTitleColor(.white, for: .normal)
        btnDelivery.backgroundColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
    }
    
    @IBAction func SeflPickUp(_ sender: UIButton)
    {
        btnDelivery.setTitleColor(UIColor.init(red: 105/255.0, green: 105/255.0, blue: 106/255.0, alpha: 1.0), for: .normal)
        btnDelivery.backgroundColor = UIColor.init(red: 236/255.0, green: 239/255.0, blue: 240/255.0, alpha: 1.0)
        btnSelfPickUp.setTitleColor(.white, for: .normal)
        btnSelfPickUp.backgroundColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
    }
    
    @objc func methodAddCart(_ sender: UIButton!)
    {
        // let addCart = AddToCartVC.init(nibName: "AddToCartVC", bundle: nil)
        // self.navigationController?.pushViewController(addCart, animated: true)
    }
    
    
    
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UITableView ViewDelegate and DataSource.........
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrKitchenMenu.count > 0
        {
            return arrKitchenMenu.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTblCell") as! RestaurantTblCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.ImgRestaurantImage.layer.cornerRadius = 8
        cell.ImgRestaurantImage.layer.masksToBounds = true
        
        let dictMenuData = arrKitchenMenu[indexPath.row] as! NSDictionary
        if dictMenuData.count > 0
        {
            cell.lblRestaurantName.text = dictMenuData.valueForNullableKey(key: kBreakfastTitle)
            cell.lblDescription.text = dictMenuData.valueForNullableKey(key: kBreakfastDescription)
            cell.ImgRestaurantImage.sd_addActivityIndicator()
            let url = URL.init(string: dictMenuData.value(forKey: kIcon) as! String)
            cell.ImgRestaurantImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell.ImgRestaurantImage.sd_removeActivityIndicator()
            })
            cell.lblPrice.text = "AED \(dictMenuData.valueForNullableKey(key: kItemPrice))"
            cell.lblDiscountedPrice.text = "AED \(dictMenuData.valueForNullableKey(key: kItemDiscountedPrice))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 177
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isNavigationFrom != "isFromWelcomeVC" && isNavigationFrom != "isFromSkipNow"
        {
            let dictMenuData = arrKitchenMenu[indexPath.row] as! NSDictionary
            let addCart = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            addCart.strKitchenMenuID = dictMenuData.valueForNullableKey(key: kId)
            addCart.isNavigation = "MealsVC"
            addCart.strKitchenName = strKitchenName
            self.navigationController?.pushViewController(addCart, animated: true)
        }
        else
        {
            if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
            {
                let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
                let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
                    
                }
                alert.addAction(actionAllow)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - kitchenMenuItems Api Method......................
    func MealParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(strMealType, forKey: kMealType as NSCopying)
        dict.setObject(strKitchenFarmID, forKey: kKitchenID as NSCopying)
        dict.setObject(self.appDelegate.SwitchType, forKey: kHumanType as NSCopying)
        
        return dict
    }
    @objc func MealMethodApi()
    {
        getallApiResultwithPostTokenMethod(Details:MealParam(), strMethodname: kMethodMenuItem) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        if (responseData?.object(forKey: kResponseDataDict) as! NSDictionary).count > 0
                        {
                            let data = (responseData?.value(forKey: kResponseDataDict) as! NSDictionary)
                            self.dictKitchenDetails = data.value(forKey: kKitchenList) as! NSDictionary
                            self.arrKitchenMenu = self.dictKitchenDetails.value(forKey: kKitchenMenu) as! NSArray
                            self.strKitchenName = self.dictKitchenDetails.value(forKey: Kitchenname) as! String
                            self.TblDeliver.reloadData()
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


