//
//  SubscribeVC.swift
//  Picky
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit
import Koyomi

class SubscribeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, KoyomiDelegate {
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var koyomi: Koyomi!
    @IBOutlet weak var tableView: UITableView!
    
    var arrPlans = NSArray()
    var arrAllDates = NSMutableArray()
    var arrEnableDates = NSMutableArray()
    var arrDisableDates = NSMutableArray()
    var arrAllconvertedDates = [Date]()
    
    var arrFinalSelectDeselect = NSMutableArray()
    
    var dictToSend = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BGView.isHidden = true
        koyomi.calendarDelegate = self
        koyomi.display(in: .current)
        koyomi.isHiddenOtherMonth = true
        koyomi.selectionMode = .multiple(style: .circle)
        koyomi.style = .orange
        let currentDateString = koyomi.currentDateString()
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.GetSubscriptionPlan), with: nil)
        }else{
            self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.dictToSend = [[:]]
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Subscribe", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    //MARK:- UIButton Actions.........
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        BGView.isHidden = true
    }
    
    @IBAction func btnDone(_ sender: UIButton)
    {
        BGView.isHidden = true
        let dict = arrPlans[sender.tag] as! NSDictionary
        let strId = dict.valueForNullableKey(key: kId)
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.MethodDateEnableDesable(strOrderId:)), with: strId)
        }else{
            self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
        }
    }
    
    @objc func methodPauseOrder(_ sender: UIButton!)
    {
        BGView.isHidden = false
        if self.appDelegate.isInternetAvailable() == true
        {
            let dict = arrPlans[sender.tag] as! NSDictionary
            let strId = dict.valueForNullableKey(key: kId)
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.GetDatesOnMap(strOrderId:)), with: strId)
        }
        else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    @objc func methodCancelOrder(_ sender: UIButton!)
    {
        if self.appDelegate.isInternetAvailable() == true
        {
            let dict = arrPlans[sender.tag] as! NSDictionary
            let strId = dict.valueForNullableKey(key: kId)
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.methodCancelOrderApi(strOrderId:)), with: strId)
        }
        else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrPlans.count>0
        {
            return arrPlans.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribeCell", for: indexPath as IndexPath) as! SubscribeCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        if arrPlans.count>0
        {
            let dict = arrPlans[indexPath.row] as! NSDictionary
            cell.lblFoodName.text = dict.valueForNullableKey(key: Kitchenname)
            cell.lblDays.text = "\(dict.valueForNullableKey(key: kDayCount)) DAYS"
            cell.lblAddress.text = dict.valueForNullableKey(key: kAddress)
            cell.lblPrice.text = "AED \(dict.valueForNullableKey(key: KTotalAmount))"
            
            let kitchenMenu = dict.object(forKey: kKitchenMenus) as! NSDictionary
            cell.foodImgView.sd_addActivityIndicator()
            let url = URL.init(string: kitchenMenu.valueForNullableKey(key: KImage))
            
            cell.foodImgView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell.foodImgView.sd_removeActivityIndicator()
            })
            
            
            if dict.valueForNullableKey(key: kisCanceled) == "1"
            {
                cell.btnCancel.isUserInteractionEnabled = false
                cell.btnPause.isUserInteractionEnabled = false
                cell.btnCancel.layer.borderColor = UIColor.lightGray.cgColor
                cell.btnCancel.setTitleColor(UIColor.lightGray, for: .normal)
                cell.btnPause.layer.borderColor = UIColor.lightGray.cgColor
                cell.btnPause.setTitleColor(UIColor.lightGray, for: .normal)
            }
            else
            {
                cell.btnCancel.tag = indexPath.row
                cell.btnPause.tag = indexPath.row
                cell.btnCancel.isUserInteractionEnabled = true
                cell.btnPause.isUserInteractionEnabled = true
                cell.btnCancel.layer.borderColor = UIColor.init(red: 228/255, green: 1/255, blue: 0/255, alpha: 1.0).cgColor
                cell.btnCancel.setTitleColor(UIColor.init(red: 228/255, green: 1/255, blue: 0/255, alpha: 1.0), for: .normal)
                cell.btnPause.layer.borderColor = UIColor.init(red: 230/255, green: 105/255, blue: 48/255, alpha: 1.0).cgColor
                cell.btnPause.setTitleColor(UIColor.init(red: 230/255, green: 105/255, blue: 48/255, alpha: 1.0), for: .normal)
                cell.btnCancel.addTarget(self, action: #selector(methodCancelOrder(_:)), for: .touchUpInside)
                cell.btnPause.addTarget(self, action: #selector(methodPauseOrder(_:)), for: .touchUpInside)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    // MARK:- Koyomi Delegates..............
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        
    }
    
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        
        let selectedDate = "\(date!)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let showDate = dateFormatter.date(from:selectedDate)
        let resultString = dateFormatter.string(from: showDate!)
        let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "yyyy-MM-dd")
        
        for (offSet, dict) in self.dictToSend.enumerated(){
            if dict["date"] as! String == resultString1{
                if dict["status"] as! String == "enable"{ // disable
                    self.dictToSend[offSet] = ["date" : resultString1, "status" : "disable"]
                }else{ // enable
                    self.dictToSend[offSet] = ["date" : resultString1, "status" : "enable"]
                }
            }
        }
        print("self.dictToSend.........",self.dictToSend)
    }
    
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        
        let dictDetail = NSMutableDictionary()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if  formatter.string(from: date!) > formatter.string(from: arrAllconvertedDates.last!)
        {
            return false
        }
        else
        {
            if formatter.string(from: arrAllconvertedDates.first!) <= formatter.string(from: date!) {
                return true
            }
            else
            {
                return false
            }
        }
    }
    
    // MARK:- Get Subscription Plan API Integration
    @objc func GetSubscriptionPlan()
    {
        
        getallApiResultwithPostTokenMethod(Details: NSDictionary(), strMethodname: kMethodMySubscriptionPlan) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.arrPlans = responseData?.object(forKey: kResponseDataDict) as! NSArray
                        self.tableView.reloadData()
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
    
    // MARK:- Get DatesOnMap Plan API Integration
    @objc func GetDatesOnMap(strOrderId: String)
    {
        let dict = NSMutableDictionary()
        
        dict.setObject(strOrderId, forKey: kOrderId as NSCopying)
        
        getallApiResultwithPostTokenMethod(Details: dict, strMethodname: kMethodDatesOnMap) { (responseData, error) in
            
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let Dictdata = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        let arrDate:NSMutableArray = (Dictdata.value(forKey: kAllDate) as! NSArray).mutableCopy() as! NSMutableArray
                        
                        for item in arrDate {
                            
                            self.arrAllDates = (arrDate.value(forKey: kOrderDate) as! NSArray).mutableCopy() as! NSMutableArray
                            // self.arrAllDates = ["2020 03 12", "2020 03 13", "2020 03 14", "2020 03 15"]//
                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        for dat in self.arrAllDates {
                            let date = dateFormatter.date(from: dat as! String)
                            if let date = date {
                                self.arrAllconvertedDates.append(date)
                            }
                        }
                        
                        self.arrAllconvertedDates.forEach { (datee) in
                            
                            let selectedDate = "\(datee)"
                            
                             let dateFormatter = DateFormatter()
                              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                              let showDate = dateFormatter.date(from:selectedDate)
                              let resultString = dateFormatter.string(from: showDate!)
                              let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "yyyy-MM-dd")
                            self.dictToSend.append(["date" : resultString1, "status" : "enable"])
                        }
                        
                        self.koyomi.select(dates: self.arrAllconvertedDates)
                        let arrayRemainingLetters = arrDates.filter {
                            !self.arrAllDates.contains($0)
                        }
                        
                        print(arrayRemainingLetters)
                        
                        var arrDeselectDates = [Date]()
                        dateFormatter.dateFormat = "yyyy MM dd"
                        for dat in arrayRemainingLetters {
                            let date = dateFormatter.date(from: dat)
                            if let date = date {
                                arrDeselectDates.append(date)
                            }
                        }
                        
                        self.koyomi.unselect(dates: arrDeselectDates)
                        
                        print("Selected Dates.............", self.arrAllconvertedDates)
                        print("unselctdate Dates.............", arrDeselectDates)
                        self.koyomi.reloadData()
                        
                        self.arrDisableDates = (Dictdata.value(forKey: kDisableDates) as! NSArray).mutableCopy() as! NSMutableArray
                        self.arrEnableDates = (Dictdata.value(forKey: kEnableDates) as! NSArray).mutableCopy() as! NSMutableArray
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
    
    // MARK:- DateEnableDesable API Integration...............
    @objc func MethodDateEnableDesable(strOrderId: String)
    {
        let dict = NSMutableDictionary()
        dict.setObject(strOrderId, forKey: kOrderId as NSCopying)
        dict.setObject(dictToSend, forKey: kDateArray as NSCopying)
        
        getallApiResultwithPostTokenMethod(Details: dict, strMethodname: kMethodEnableDisableDate) { (responseData, error) in
            
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        
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
    
    //MARK: method Cancel Order Api............
    @objc func methodCancelOrderApi(strOrderId: String)
    {
        let dict = NSMutableDictionary()
        
        dict.setObject(strOrderId, forKey: kOrderId as NSCopying)
        
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
                                if self.appDelegate.isInternetAvailable() == true
                                {
                                    self.showActivity(text: "")
                                    self.performSelector(inBackground: #selector(self.GetSubscriptionPlan), with: nil)
                                }
                                else
                                {
                                    self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
                                }
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

