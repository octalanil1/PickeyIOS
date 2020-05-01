//
//  OrderCartVC.swift
//  Pickey
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit


class OrderDetailHeader: UITableViewCell {
    @IBOutlet weak var lblName : UILabel?
    @IBOutlet weak var lblCategoryName : UILabel?
}

class OrderDetailNewCell: UITableViewCell {
    @IBOutlet weak var imgOrder : UIImageView?
    @IBOutlet weak var lblName : UILabel?
    @IBOutlet weak var lblPrice : UILabel?
}

class OrderDetailPriceCell: UITableViewCell {
    
    @IBOutlet weak var lblTotalPrice : UILabel?
}


class OrderCartVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var tblMenu: UITableView!
//    @IBOutlet weak var lblBunchName: UILabel!
    @IBOutlet weak var btnCancelOrder: ShadowButton?
    @IBOutlet weak var lblMode : UILabel?
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
   // @IBOutlet weak var lblDateAndTime: UILabel!
   // @IBOutlet weak var lblRsetaurantName: UILabel!
    @IBOutlet weak var btnOrderStatus: ShadowButton!
    @IBOutlet weak var lblOrderNumber: UILabel!
    
    @IBOutlet weak var tbl_data:UITableView!
    var isNavigation = ""
    var strOrderId = ""
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
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Order Details", leftbuttonImageName: "back", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodBackBtnAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- UIButton Actions.........
    @objc func methodBackBtnAction(_ sender: UIButton!)
    {
        if isNavigation == "Payment"
        {
            self.appDelegate.showtabbar()
        }
        else
        {
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func methodAddCart(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- UIButton Actions.........
    @IBAction func methodBtnCancelOrder(_ sender: UIButton!)
    {
        if self.appDelegate.isInternetAvailable() == true
        {
            
            let alert = UIAlertController(title: kAppName, message: "Reason for cancel", preferredStyle: .alert)
            
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.delegate = self
                    textField.placeholder = "Write Reason"
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                                 
                                  //print("Text field: \(textField?.text)")
                              }))
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                     let name = (textField?.text)?.trimmingCharacters(in: .whitespaces)
                   if name!.count == 0
                   {
                      self.onShowAlertController(title: kError, message: "Please enter reason.")
                      
                       return
                   }
                    self.showActivity(text: "")
                    self.performSelector(inBackground: #selector(self.methodCancelOrderApi(strOrderId:)), with: name)
                }))
              self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    func registercell()
    {
        tbl_data.register(UINib(nibName: "OrderAddressCell", bundle: nil), forCellReuseIdentifier: "OrderAddressCell")
        tbl_data.register(UINib(nibName: "OrderFromTblCell", bundle: nil), forCellReuseIdentifier: "OrderFromTblCell")
        tbl_data.register(UINib(nibName: "OrderAmountCell", bundle: nil), forCellReuseIdentifier: "OrderAmountCell")
    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0//Top header
//        {
//            return 1
//        }
//        else if section == 1{//Ordercell
//            if arrItemList.count>0
//            {
//                return arrItemList.count
//            }
//            else{
//                return 0
//            }
//        }
//        else //orderdetails
//        {
//            return 1
//        }
//
//    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let cell : OrderDetailPriceCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailPriceCell") as! OrderDetailPriceCell
              // let dict = self.arrItemList.object(at: section) as! NSDictionary
        cell.contentView.alpha = 0.0
        if self.arrItemList.count - 1 == section
        {
        cell.lblTotalPrice?.text = "AED \(self.dictOrderDetail.object(forKey: "total_amount") as? String ?? "0")"
            cell.contentView.alpha = 1.0
        }
              
            return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let cell : OrderDetailHeader = tableView.dequeueReusableCell(withIdentifier: "OrderDetailHeader") as! OrderDetailHeader
        let dict = self.arrItemList.object(at: section) as! NSDictionary
        cell.lblName?.text = dict.object(forKey: "kitchen_name") as? String
        cell.lblCategoryName?.text = dict.object(forKey: "kitchen_category_name") as? String
           return cell.contentView
       }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.arrItemList.count>0
           {
               return arrItemList.count
           }
           else{
                return 0
           }
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let dict = self.arrItemList.object(at: section) as! NSDictionary
        let arrayD = dict.object(forKey: "order_date") as! NSArray
        if arrayD.count>0
        {
            return arrayD.count
        }
        else{
             return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0
//        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailNewCell") as! OrderDetailNewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
        let dict = self.arrItemList.object(at: indexPath.section) as! NSDictionary
        let arrayOrder = dict.object(forKey: "order_date") as! NSArray
        let orderDetail = arrayOrder.object(at: indexPath.row) as! NSDictionary
        cell.lblName?.text = orderDetail.object(forKey: "order_menu_name") as? String
        cell.lblName?.text = dict.object(forKey: "price") as? String
        cell.imgOrder?.sd_addActivityIndicator()
        let url = URL.init(string: orderDetail.valueForNullableKey(key: "item_image") ?? "")
        cell.imgOrder?.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
        cell.imgOrder?.sd_removeActivityIndicator()
                   })
        cell.imgOrder?.layer.cornerRadius = 8.0
        cell.imgOrder?.layer.masksToBounds = true
        
        
          //  cell.imgRestaurant.layer.cornerRadius = 8
          //  cell.imgRestaurant.layer.masksToBounds = true
//            cell.lblOrderNumber.text = "Order Number: \(self.dictOrderDetail.object(forKey: "order_number") as? String ?? "")"
//            cell.lblMode?.text = "Child Mode"
//            cell.lblDateAndTime.text = "From \(dictOrderDetail.object(forKey: "delivery_from_time") as? String ?? "") to \(dictOrderDetail.object(forKey: "delivery_to_time") as? String ?? "")"
//            cell.lblAddress.text = self.dictOrderDetail.object(forKey: "delivery_address") as? String ?? "N/A"
            
//            if dictOrderDetail.count>0
//            {
//                let dictKitchenDetails = dictOrderDetail.object(forKey: kKitchenDetails) as! NSDictionary
//                //let dictKitchenMenuDetails = dictOrderDetail.object(forKey: kMethodKitchenMenuDetail) as! NSArray
//               // cell.lblBunchName.text = dictKitchenDetails.valueForNullableKey(key: kName)
//
//                let SelectDate = dictKitchenDetails.valueForNullableKey(key: kOrderCreated)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let showDate = dateFormatter.date(from:SelectDate)
//                let resultString = dateFormatter.string(from: showDate!)
//                let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "EEEE, MMM d, yyyy h:mm a")
//
//                cell.lblRsetaurantName.text = dictKitchenDetails.valueForNullableKey(key: kName)
//                cell.lblAddress.text = dictKitchenDetails.valueForNullableKey(key: kDeliveryAddress)
//                cell.lblDateAndTime.text = resultString1
//                cell.lblOrderNumber.text = "Order Number: \(dictOrderDetail.valueForNullableKey(key: kId))"
//                cell.imgRestaurant.sd_addActivityIndicator()
//                let url = URL.init(string: dictKitchenDetails.valueForNullableKey(key: KImage))
//                cell.imgRestaurant.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
//                cell.imgRestaurant.sd_removeActivityIndicator()
//                })
//                cell.btnCancelOrder.tag = indexPath.row
//                cell.btnCancelOrder.addTarget(self, action: #selector(methodBtnCancelOrder(_:)), for: .touchUpInside)
//                if dictOrderDetail.valueForNullableKey(key: kDeliveryTimeFrom) == ""
//                {
//                    cell.lblDeliveryTime.text = "From 00:00"
//                }
//                else
//                {
//                    cell.lblDeliveryTime.text = "From \(dictOrderDetail.valueForNullableKey(key: kDeliveryTimeFrom) + "-" + dictOrderDetail.valueForNullableKey(key: kDeliveryTimeTo))"
//                }
//                if dictOrderDetail.valueForNullableKey(key: kDeliveryStatus) == "0"
//                {
//                    cell.btnOrderStatus.setTitle("RUNNING", for: .normal)
//                    cell.btnOrderStatus.borderColor = .red
//                    cell.btnOrderStatus.setTitleColor(.red, for: .normal)
//                }
//                else if dictOrderDetail.valueForNullableKey(key: kDeliveryStatus) == "1"
//                {
//                   cell.btnOrderStatus.setTitle("COMPLETE", for: .normal)
//                    cell.btnOrderStatus.borderColor = UIColor.init(red: 113/255.0, green: 175/255.0, blue: 61/255.0, alpha: 1.0)
//                    cell.btnOrderStatus.setTitleColor(UIColor.init(red: 113/255.0, green: 175/255.0, blue: 61/255.0, alpha: 1.0), for: .normal)
//                }
//                else
//                {
//                    cell.btnOrderStatus.setTitle("PAUSE", for: .normal)
//                    cell.btnOrderStatus.borderColor = .red
//                    cell.btnOrderStatus.setTitleColor(.red, for: .normal)
//                }
//                if dictOrderDetail.valueForNullableKey(key: kisCanceled) == "1"
//                {
//                    cell.viewCancelOrder.isHidden = true
//                    cell.btnOrderStatus.setTitle("Cancel", for: .normal)
//                    cell.btnOrderStatus.borderColor = .red
//                    cell.btnOrderStatus.setTitleColor(.red, for: .normal)
//                }
//                else
//                {
//                    cell.viewCancelOrder.isHidden = false
//                }
//            }
            return cell
//        }
//        else if indexPath.section == 1
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFromTblCell") as! OrderFromTblCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .clear
//
//            cell.ViewShadow.isHidden = true
//            cell.btnDelete.isHidden = true
//            cell.lblTotalPrice.isHidden = true
//            if arrItemList.count>0
//            {
//               // let dictItem = arrItemList[indexPath.row] as! NSArray
//                let dictItem = (dictOrderDetail.object(forKey: kMethodKitchenMenuDetail) as! NSArray).object(at: indexPath.row) as! NSDictionary
//                cell.lblMenuName.text = dictItem.valueForNullableKey(key: kName)
//                cell.lblMenuPrice.text = dictItem.valueForNullableKey(key: KitchenDescrition)
//                cell.imgMenu.sd_addActivityIndicator()
//                let url = URL.init(string: dictItem.valueForNullableKey(key: KImage))
//                cell.imgMenu.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
//                cell.imgMenu.sd_removeActivityIndicator()
//                })
           // }
//            return cell
//        }
//        else
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAmountCell") as! OrderAmountCell
//            cell.selectionStyle = .none
//            cell.backgroundColor = .clear
//            if dictOrderDetail.count>0
//            {
//                let dictKitchenDetails = dictOrderDetail.object(forKey: kMethodKitchenMenuDetail) as! NSArray
//                cell.lblTtalPrice.text = "AED \(dictOrderDetail.valueForNullableKey(key: KTotalAmount))"
//
//                let arrOrderDelivery = dictKitchenDetails.value(forKey: kOrderDelivery) as! NSArray
//                if arrOrderDelivery.count>0
//                {
//                    let arrDelivery = arrOrderDelivery.object(at: 0) as! NSArray
//                    let dictOrderDelivery = arrDelivery.object(at: 0) as! NSDictionary
//                    let SelectDate = dictOrderDelivery.value(forKey: kOrderDate) //valueForNullableKey(key: kOrderDate)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd"
//                    let showDate = dateFormatter.date(from:SelectDate as! String)
//                    let resultString = dateFormatter.string(from: showDate!)
//                    let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd", toFormat: "EEEE, MMM d")
//                    cell.lblDate.text = resultString1
//
//                    let strOrderStatus = dictOrderDelivery.value(forKey: kOrderStatus) as! String //valueForNullableKey(key: kOrderStatus)
//                    if strOrderStatus == "0"{
//                        cell.lblStatus.text = "Pending"
//                    }else{
//                        cell.lblStatus.text = "Confirm"
//                    }
//                }
//            }
//            return cell
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
//        if indexPath.section == 0{
//            return 255
//            //return UITableView.automaticDimension
//        }else if indexPath.section == 1{
//            return UITableView.automaticDimension
//        }else{
//            return 140
       // }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 93.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.arrItemList.count - 1 == section
               {
                return 60.0
        }
        return 5.0
    }
    
    //MARK: - AddReview Api Integration................
    func OrderDetailsParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(strOrderId, forKey: kOrderId as NSCopying)
        return dict
    }
    @objc func MethodOrderDetailspi()
    {
        getallApiResultwithPostTokenMethod(Details:OrderDetailsParam(), strMethodname: kMethodOrderDetail ) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.dictOrderDetail = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        
                        self.arrItemList = self.dictOrderDetail.object(forKey: "order_plan") as! NSArray
                       // let orderDetailArray = self.dictOrderDetail.object(forKey: kMethodKitchenMenuDetail) as! NSArray
                      //  let DictKitchen = self.dictOrderDetail.object(forKey: kMethodKitchenMenuDetail) as! NSArray
                       // self.arrItemList = DictKitchen.value(forKey: KItems) as! NSArray
                        
                        
                        self.lblOrderNumber.text = "Order Number: \(self.dictOrderDetail.object(forKey: "order_number") as? String ?? "")"
                        self.lblMode?.text = "Child Mode"
                        self.lblDeliveryTime.text = "From \(self.dictOrderDetail.object(forKey: "delivery_from_time") as? String ?? "") to \(self.dictOrderDetail.object(forKey: "delivery_to_time") as? String ?? "")"
                        self.lblAddress.text = self.dictOrderDetail.object(forKey: "delivery_address") as? String ?? "N/A"
                        
                        if self.dictOrderDetail.valueForNullableKey(key: kResponseDataStatus) == "0"
                        {
                            self.btnOrderStatus.setTitle("RUNNING", for: .normal)
                            self.btnOrderStatus.borderColor = .red
                            self.btnOrderStatus.setTitleColor(.red, for: .normal)
                        }
                        else if self.dictOrderDetail.valueForNullableKey(key: kResponseDataStatus) == "1"
                        {
                            self.btnOrderStatus.setTitle("COMPLETE", for: .normal)
                            self.btnOrderStatus.borderColor = UIColor.init(red: 113/255.0, green: 175/255.0, blue: 61/255.0, alpha: 1.0)
                            self.btnOrderStatus.setTitleColor(UIColor.init(red: 113/255.0, green: 175/255.0, blue: 61/255.0, alpha: 1.0), for: .normal)
                        }
                        else{
                            self.btnOrderStatus.setTitle("PAUSE", for: .normal)
                            self.btnOrderStatus.borderColor = .red
                            self.btnOrderStatus.setTitleColor(.red, for: .normal)
                        }
                        if self.dictOrderDetail.valueForNullableKey(key: kisCanceled) == "0"
                        {
                            self.btnCancelOrder?.setTitle("Cancel", for: .normal)
                            self.btnCancelOrder?.borderColor = .red
                            self.btnCancelOrder?.setTitleColor(.red, for: .normal)
                            self.btnCancelOrder?.alpha = 1.0
                        }
                        else
                        {
                            self.btnOrderStatus.setTitle("CANCELLED", for: .normal)
                            self.btnOrderStatus.borderColor = .red
                            self.btnOrderStatus.setTitleColor(.red, for: .normal)
                            self.btnCancelOrder?.alpha = 0.0
                        }
                               
                        
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
    
     //MARK: method Cancel Order Api............
    @objc func methodCancelOrderApi(strOrderId: String)
    {
        let dict = NSMutableDictionary()
        let strOrder = dictOrderDetail.valueForNullableKey(key: kId)
        dict.setObject(strOrder, forKey: kOrderId as NSCopying)
        dict.setObject(strOrderId, forKey: kReasonCancel as NSCopying)
        
        getallApiResultwithPostTokenMethod(Details: dict, strMethodname: kMethodCancelOrder) { (responseData, error) in
            
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let data = responseData?.valueForNullableKey(key: kMessage)
                        let alertView = UIAlertController(title: "", message: data, preferredStyle: .alert)
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
                        self.onShowAlertController(title: "Error" , message: responseData?.value(forKey: "msg") as! String?)
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
