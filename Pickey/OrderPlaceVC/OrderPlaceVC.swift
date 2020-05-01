//
//  OrderPlaceVC.swift
//  Pickey
//
//  Created by octal on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class OrderPlaceVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tbl_data:UITableView!
    var strOrderID = ""
    var isNavigation = ""
    var dictOrderDetail = NSDictionary()
    var arrItemList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registercell()
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.MethodOrderDetailspi), with: nil)
            
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Order Placed", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(title: "", style:  .done, target: self, action: #selector(methodBackBtnAction(_:))) //init(image: UIImage.init(named: "")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodBackBtnAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- UIButton Actions.........
    @objc func methodBackBtnAction(_ sender: UIButton!)
    {
        
    }
    
    @IBAction func btnDone(_ sender: UIButton)
    {
        self.appDelegate.showtabbar()
    }
    
    func registercell()
    {
        tbl_data.register(UINib(nibName: "TopHeaderCell", bundle: nil), forCellReuseIdentifier: "TopHeaderCell")
        //tbl_data.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        tbl_data.register(UINib(nibName: "OrderDetailCell", bundle: nil), forCellReuseIdentifier: "OrderDetailCell")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0//Top header
        {
            return 1
        }
//        else if section == 1{//Ordercell
//            if arrItemList.count>0
//            {
//                return arrItemList.count
//            }else{
//                return 0
//            }
//        }
        else //orderdetails
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopHeaderCell") as! TopHeaderCell
           cell.selectionStyle = .none
           cell.backgroundColor = .clear
            if dictOrderDetail.count>0{
                //let dictKitchenDetails = dictOrderDetail.object(forKey: kKitchenDetails) as! NSDictionary
                cell.lblRestaurentName.text = dictOrderDetail.valueForNullableKey(key: Kitchenname)
            }
            return cell
        }
//        else if indexPath.section == 1
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .clear
//            if arrItemList.count>0
//            {
//                let dictItem = arrItemList[indexPath.row] as! NSDictionary
//                cell.lblMenuName.text = dictItem.valueForNullableKey(key: kItem)
//                cell.lblDescription.text = dictItem.valueForNullableKey(key: KitchenDescrition)
//            }
//
//            return cell
//        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell") as! OrderDetailCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if dictOrderDetail.count>0{
                
                let dictKitchenAddress = self.dictOrderDetail.object(forKey: kAddress) as! NSDictionary
                //let dictKitchenMenuDetail = dictOrderDetail.object(forKey: kMethodKitchenMenuDetail) as! NSDictionary
               // cell.lblMenuQuantity.text = dictKitchenDetails.valueForNullableKey(key: kName) + " X " +  dictOrderDetail.valueForNullableKey(key: kQty)
                let SelectDate = dictOrderDetail.valueForNullableKey(key: kOrderDateTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let showDate = dateFormatter.date(from:SelectDate)
                let resultString = dateFormatter.string(from: showDate!)
                let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "EEEE, MMM d, yyyy h:mm a")
                cell.lblDateAndTime.text = "Order date & time: \(resultString1)"
                cell.lblOrderNumber.text = "Order Number: \(dictOrderDetail.valueForNullableKey(key: kOrderId))"
                cell.lblAddress.text = dictKitchenAddress.valueForNullableKey(key: kFlatNumber) +
                    " " + dictKitchenAddress.valueForNullableKey(key: kAddress)
                cell.lblAmount.text = "AED \(dictOrderDetail.valueForNullableKey(key: kOrderAmount))"
                
                if dictOrderDetail.valueForNullableKey(key: kDeliveryTimeFrom) == ""
                {
                    cell.lblRestaurentCloseTime.text = "From 00:00"
                }else{
                    cell.lblRestaurentCloseTime.text = "From \(dictOrderDetail.valueForNullableKey(key: kDeliveryTimeFrom) + "-" + dictOrderDetail.valueForNullableKey(key: kDeliveryTimeTo))"
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 255
        }
//        else if indexPath.section == 1
//        {
//            return 52
//        }
        else{
            return 210
        }
    }
    
    //MARK: - AddReview Api Integration................
    func OrderDetailsParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(strOrderID, forKey: kOrderId as NSCopying)
        return dict
    }
    @objc func MethodOrderDetailspi()
    {
        getallApiResultwithPostTokenMethod(Details:OrderDetailsParam(), strMethodname: kMethodOrderSuccess ) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        
                        self.dictOrderDetail = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                      //  let DictKitchen = self.dictOrderDetail.object(forKey: kAddress) as! NSDictionary
                      // self.arrItemList = DictKitchen.value(forKey: KItems) as! NSArray
                        self.tbl_data.reloadData()
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

