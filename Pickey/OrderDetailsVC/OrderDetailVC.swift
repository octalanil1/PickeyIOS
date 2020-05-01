//
//  OrderDetailVC.swift
//  Pickey
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit




class OrderDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tbl_data:UITableView!
    
    var dictOrderDetail = NSDictionary()
    var arrMyOrderList = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tbl_data.register(UINib(nibName: "OrderDeliveryCell", bundle: nil), forCellReuseIdentifier: "OrderDeliveryCell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "My Order", leftbuttonImageName: "", RightbuttonName: "")
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.MyOrderListApi), with: nil)
                   
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
        
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @objc func methodAddCart(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrMyOrderList.count>0
        {
            return arrMyOrderList.count
        }
        else{
             return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDeliveryCell") as! OrderDeliveryCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        //cell.imgFood.layer.cornerRadius = 8
       // cell.imgFood.layer.masksToBounds = true
        
        if arrMyOrderList.count>0
        {
            let dictMyOrder = arrMyOrderList[indexPath.row]as! NSDictionary
            cell.lblPrice.text = "AED " + dictMyOrder.valueForNullableKey(key: KTotalAmount)
           
            let SelectDate = dictMyOrder.valueForNullableKey(key: KitchenCreatedDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let showDate = dateFormatter.date(from:SelectDate)
            let resultString = dateFormatter.string(from: showDate!)
            let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "EEEE, MMM d, yyyy h:mm a")
             cell.lblDate.text = resultString1
            
            if dictMyOrder.valueForNullableKey(key: kResponseDataStatus) == "0"
            {
                cell.btnConfirm.setTitle("RUNNING", for: .normal)
                cell.btnConfirm.borderColor = .red
                cell.btnConfirm.setTitleColor(.red, for: .normal)
            }
            else if dictMyOrder.valueForNullableKey(key: kResponseDataStatus) == "1"
            {
                cell.btnConfirm.setTitle("COMPLETE", for: .normal)
                cell.btnConfirm.borderColor = UIColor.init(red: 113/255.0, green: 175/255.0, blue: 61/255.0, alpha: 1.0)
                cell.btnConfirm.setTitleColor(UIColor.init(red: 113/255.0, green: 175/255.0, blue: 61/255.0, alpha: 1.0), for: .normal)
            }
            else{
                cell.btnConfirm.setTitle("PAUSE", for: .normal)
                cell.btnConfirm.borderColor = .red
                cell.btnConfirm.setTitleColor(.red, for: .normal)
            }
            if dictMyOrder.valueForNullableKey(key: kisCanceled) == "1"
            {
                cell.btnConfirm.setTitle("CANCELLED", for: .normal)
                cell.btnConfirm.borderColor = .red
                cell.btnConfirm.setTitleColor(.red, for: .normal)
            }
            
            let orderPlan = dictMyOrder.object(forKey: kOrderPlan) as? NSArray
            let dict = orderPlan?.object(at: 0) as? NSDictionary
           // cell.lblFoodName.text = dict?.valueForNullableKey(key: Kitchenname)
         /*   cell.imgFood.sd_addActivityIndicator()
            let url = URL.init(string: dict?.valueForNullableKey(key: KitchenImage) ?? "")
            cell.imgFood.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            cell.imgFood.sd_removeActivityIndicator()
            })*/
            
//            let dict = dictMyOrder.object(forKey: kKitchenDetails) as! NSDictionary
//            cell.lblFoodName.text = dict.valueForNullableKey(key: kName)
//            cell.imgFood.sd_addActivityIndicator()
//            let url = URL.init(string: dict.valueForNullableKey(key: KImage))
//            cell.imgFood.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
//                cell.imgFood.sd_removeActivityIndicator()
           // })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if arrMyOrderList.count>0
        {
            let dictMyOrder = arrMyOrderList[indexPath.row]as! NSDictionary
            let strOrderId = dictMyOrder.valueForNullableKey(key: kId)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderCartVC") as! OrderCartVC
            vc.strOrderId = strOrderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: MyOrderList API Integration.................
    @objc func MyOrderListApi()
    {
        getallApiResultwithPostTokenMethod(Details: NSDictionary(), strMethodname: kMethodMyOrders) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.arrMyOrderList = responseData?.value(forKey: kResponseDataDict) as! NSArray
                        self.tbl_data.reloadData()
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
