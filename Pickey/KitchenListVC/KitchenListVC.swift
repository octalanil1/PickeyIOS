//
//  KitchenListVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 30/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import CoreLocation

class customTable : UITableView
{
    var rowIndex = -1
    var sectionIndex = -1
    var selectionIndex = -1
}
class KitchenListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var tblKitchenList: UITableView!
    @IBOutlet weak var btnKitchen:UIButton!
    @IBOutlet weak var btnFarms:UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var CollViewCalender: UICollectionView!
    @IBOutlet weak var CollViewPromo: UICollectionView!
    @IBOutlet weak var lblCartCount : UILabel?
    
    @IBOutlet weak var imgArrow:UIImageView!
    
    var locationManager = CLLocationManager()
    var arrKitchenList = NSMutableArray()
    var arrCategoryList = NSMutableArray()
    var arrMenuList = NSMutableArray()
    var arrPromoList = NSMutableArray()
    var dictKitchenData = NSDictionary()
    var isLocationReceived: Bool = true
    //var strSelectFormattedString = ""
    var strKitchenFarmID = ""
    var strCartExist = ""
    var headerTextCount = ""
    var begin = false
    var index = 0
    var inForwardDirection = true
    var timer: Timer?
    var isSelectedIndex = 0
    var isIndexSelected = false
    var sectionCount : Int = Int()
    var customTblClass = customTable()
    
    
    //MARK:- SystemDefined Methods.........................
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblCartCount?.layer.cornerRadius = (self.lblCartCount?.frame.size.height ?? 21.0) / 2.0
        self.lblCartCount?.layer.masksToBounds = true
        self.lblCartCount?.alpha = 0.0
        
        //addInputAccessoryForTextFields(textFields: [txtSearch], dismissable: true, previousNextable: true)
        let nib1 = UINib(nibName: "DateCollCell", bundle: nil)
        CollViewCalender.register(nib1, forCellWithReuseIdentifier: "DateCollCell")
        
        let nib2 = UINib(nibName: "PromoCollCell", bundle: nil)
        CollViewPromo.register(nib2, forCellWithReuseIdentifier: "PromoCollCell")
        
        tblKitchenList.register(UINib(nibName: "CategoryNameTblCell", bundle: nil), forCellReuseIdentifier: "CategoryNameTblCell")
        
        if UIDevice.current.screenType == .iPhone_11Pro
        {
            imgDropDown.frame = CGRect(x: 25, y: 205, width: 20, height: 10)
        }else{
            imgDropDown.frame = CGRect(x: 25, y: 180, width: 20, height: 10)
        }
        
        if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
        {
            self.lblAddress.text = "Dashboard"
            self.lblAddress.textColor = UIColor(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            self.imgArrow.isHidden = true
            UserDefaults.standard.setValue("No", forKey: kIsRemeber)
        }else{
            self.lblAddress.text = StrCurrentaddress
            self.imgArrow.isHidden = false
        }
        
        arrSelectDateList = []
        strSelectFormattedString = ""
        
        arrDatesInGivenMonthYear = getDates(forLastNDays: 6)
        //Convert Date Format like dd/mm/yyy to d/m/yy.......................
        year = Int(self.appDelegate.formattedDate.convertDatetring_TopreferredFormat(currentFormat: "EEEE-yyyy-mm-dd", toFormat: "yyyy"))!
        month = Int(self.appDelegate.formattedDate.convertDatetring_TopreferredFormat(currentFormat: "EEEE-yyyy-mm-dd", toFormat: "m"))!
        
        CollViewPromo.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"{
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.tabBarController?.tabBar.isHidden = false
        }
        
       self.appDelegate.locationManager.delegate = self
        self.appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.appDelegate.locationManager.distanceFilter = 2000
        self.appDelegate.locationManager.requestWhenInUseAuthorization()
        self.appDelegate.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                self.appDelegate.ShowSettingsAlert(message: kLocationAccess)
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                // Thread.sleep(forTimeInterval: 0.5)
                self.startTimer()
                self.GetKitchenList()
            }
        }
        else
        {
            self.appDelegate.ShowSettingsAlert(message: kLocationAccess)
        }

        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: NSNotification.Name(rawValue: "sendFilter"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReplaceOrder(notification:)), name: NSNotification.Name(rawValue: "ReplaceOrder"), object: nil)
    }
    
    //MARK:- Notification updateData.........................
    
    @objc func updateData(notification: NSNotification)
    {
        let data = notification.object
        print("Rating Type..............",data)
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.KitchenMethodApi()
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    //MARK:- Replace Order Notification Get FromAddToCart Screen.........................
    @objc func ReplaceOrder(notification: NSNotification)
    {
        dictReplaceParameter = notification.object as! NSMutableDictionary
        print("replaceOrderParameter..............",dictReplaceParameter)
    }
    
    
    //MARK:- UIButton Action.........................
    
    @IBAction func btnCart(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func methodMenu(_ sender: UIButton) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func btnFilter(_ sender: UIButton)
    {
        let secondVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterVC"))!
        //add child VC
        self.addChild(secondVC)
        secondVC.view.frame = self.view.bounds
        self.view.addSubview(secondVC.view)
        secondVC.didMove(toParent: self)
    }
    
    @IBAction func btnAdressChange(_ sender: UIButton)
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
            let vc = storyboard?.instantiateViewController(withIdentifier: "ManageAccountVC") as! ManageAccountVC
            vc.isNavigation = "KitchenList"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnKitchen(_ sender: UIButton)
    {
        tblKitchenList.isHidden = false
        btnFarms.setTitleColor(UIColor.init(red: 105/255.0, green: 105/255.0, blue: 106/255.0, alpha: 1.0), for: .normal)
        btnFarms.backgroundColor = UIColor.init(red: 236/255.0, green: 239/255.0, blue: 240/255.0, alpha: 1.0)
        
        btnKitchen.setTitleColor(.white, for: .normal)
        btnKitchen.backgroundColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
        appDelegate.StrDeliverytype = "Delivery"
        //  GetKitchenList()
    }
    
    @IBAction func btnFarm(_ sender: UIButton)
    {
        btnKitchen.setTitleColor(UIColor.init(red: 105/255.0, green: 105/255.0, blue: 106/255.0, alpha: 1.0), for: .normal)
        btnKitchen.backgroundColor = UIColor.init(red: 236/255.0, green: 239/255.0, blue: 240/255.0, alpha: 1.0)
        
        btnFarms.setTitleColor(.white, for: .normal)
        btnFarms.backgroundColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
        //tblKitchenList.isHidden = true
        appDelegate.StrDeliverytype = "Self PickUp"
        // GetKitchenList()
    }
    
    @objc func btnKitchenMoreDetail(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "KitchenDetailVC") as! KitchenDetailVC
        vc.dictKitchenDetails = self.arrKitchenList.object(at: sender.tag) as! NSDictionary
        vc.strKitchenName = dictKitchenData.valueForNullableKey(key: Kitchenname)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnAddToCart(_ sender: ShadowButton)
    {
        let indexP = NSIndexPath.init(row: sender.tagRowIndex, section: sender.tagSectionIndex)
        let tblView = sender.superview?.superview?.superview?.superview as? UITableView
        let cell  = tblView?.cellForRow(at: indexP as IndexPath) as? CategoryTblCell
         // let tab = cell?.tblCategory
         
        // print(tab)
         
         
         
        let dictKitchen = arrKitchenList.object(at: cell?.sectionIndex ?? 0) as! NSDictionary

        //print(dictKitchen)
        let arrCategory = dictKitchen.object(forKey: kKitchenCategory) as! NSArray
        let dictCategory = arrCategory[(tblView?.tag)!] as! NSDictionary

        //print(dictCategory)
        let arrkitchenMenu = dictCategory.object(forKey: kCategoryMenu) as! NSArray
        let dictKitchenMenu = arrkitchenMenu[indexP.row] as! NSDictionary

        // print(dictKitchenMenu)
        let dictCart = dictKitchenMenu.object(forKey: "cart") as! NSDictionary
        
        
//        let dictKitchen = arrKitchenList.object(at: customTblClass.sectionIndex) as! NSDictionary
//
//        //print(dictKitchen)
//        let arrCategory = dictKitchen.object(forKey: kKitchenCategory) as! NSArray
//        let dictCategory = arrCategory[sender.tagSectionIndex] as! NSDictionary
//
//        //print(dictCategory)
//        let arrkitchenMenu = dictCategory.object(forKey: kCategoryMenu) as! NSArray
//        let dictKitchenMenu = arrkitchenMenu[sender.tagRowIndex] as! NSDictionary
//
//        // print(dictKitchenMenu)
//        let dictCart = dictKitchenMenu.object(forKey: "cart") as! NSDictionary
        var PlanID = ""
        var PlanDay = ""
        
        if dictCart.count>0
        {
            PlanID = dictCart.valueForNullableKey(key: kPlanid)
            PlanDay = dictCart.valueForNullableKey(key: kPlanDay)
        }
        
        strCartExist = dictKitchenMenu.valueForNullableKey(key: kCartExist)
        if strCartExist == "0"
        {
            let addCart = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            addCart.strKitchenMenuID = dictKitchenMenu.valueForNullableKey(key: kId)
            addCart.strKitchenFarmID = dictKitchen.valueForNullableKey(key: kKitchenID)
            addCart.isNavigation = "MealsVC"
            addCart.strKitchenName = dictKitchenData.valueForNullableKey(key: Kitchenname)
            self.navigationController?.pushViewController(addCart, animated: true)
        }
        else
        {
            let dict = NSMutableDictionary()
            dict.setObject(dictKitchen.valueForNullableKey(key: kKitchenID), forKey: kKitchenID as NSCopying)
            dict.setObject(dictCategory.valueForNullableKey(key: kCategoryId), forKey: kKitchenCategoryId as NSCopying)
            dict.setObject(dictKitchenMenu.valueForNullableKey(key: kId), forKey: kKitchenMenuId as NSCopying)
            dict.setObject(dictKitchenMenu.valueForNullableKey(key: kItemPrice), forKey: kPrice as NSCopying)
            dict.setObject("1", forKey: kQuantity as NSCopying)
            dict.setObject(PlanID, forKey: kPlanid as NSCopying)
            dict.setObject(PlanDay, forKey: kPlanDay as NSCopying)
            dict.setObject("1", forKey: kDays as NSCopying)
            
            getallApiResultwithPostTokenMethod(Details:dict, strMethodname: kMethodAddToCart) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            if self.appDelegate.isInternetAvailable() == true
                            {
                                self.windowShowActivity(text: "")
                                self.KitchenMethodApi()
                            } else
                            {
                                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                            }
                            self.onShowAlertController(title: "Item added cart successfully!!", message: "Item added cart successfully!!")
                        }
                        else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseChange)
                        {
                            let alertView = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
                            
                            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    
                                    let strCartID = dictCart.valueForNullableKey(key: kCartId)
                                    
                                    if self.appDelegate.isInternetAvailable() == true{
                                        self.windowShowActivity(text: "")
                                        
                                        self.performSelector(inBackground: #selector(self.MethodDeleteCartAPI(idx:)), with: strCartID)
                                    }else
                                    {
                                        self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
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
    
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if self.appDelegate.isInternetAvailable() == true
        {
            //self.windowShowActivity(text: "")
            self.KitchenMethodApi()
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.appDelegate.isInternetAvailable() == true
        {
            //self.windowShowActivity(text: "")
            self.KitchenMethodApi()
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
        return true
    }
    
    
    
    //MARK:- scrollAutomatically1 Delegates.........
    @objc func scrollAutomatically1(_ timer1: Timer)
    {
        if self.arrPromoList.count>0
        {
            let collect =  CollViewPromo
            if let coll  = collect {
                for cell in coll.visibleCells {
                    let indexPath: IndexPath? = coll.indexPath(for: cell)
                    if ((indexPath?.row)!  < (arrPromoList.count-1)){
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                        
                        coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    }
                    else{
                        let indexPath1: IndexPath?
                        indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                        coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func scrollToNextCell() {
        
        //scroll to next cell
        if self.arrPromoList.count>0
        {
            let items = CollViewPromo.numberOfItems(inSection: 0)
            if (items - 1) == index {
                CollViewPromo.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
            } else if index == 0 {
                CollViewPromo.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
            } else {
                CollViewPromo.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            }
            
            if inForwardDirection {
                if index == (items - 1) {
                    index -= 1
                    inForwardDirection = false
                } else {
                    index += 1
                }
            } else {
                if index == 0 {
                    index += 1
                    inForwardDirection = true
                } else {
                    index -= 1
                }
            }
        }
    }
    
    
    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    
    func startTimer() {
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        
    }
    
    
    
    
    
    //MARK: - UICollection ViewDelegate and DataSource.........
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag == 101
        {
            return arrDatesInGivenMonthYear.count
        }
        else
        {
            return self.arrPromoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 101
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollCell", for: indexPath) as! DateCollCell
            if self.isSelectedIndex == indexPath.row
            {
                cell.lblDate.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
                cell.lblWeekDayName.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            }
            else
            {
                cell.lblDate.textColor = UIColor.init(red: 149/255.0, green: 152/255.0, blue: 153/255.0, alpha: 1.0)
                cell.lblWeekDayName.textColor = UIColor.init(red: 149/255.0, green: 152/255.0, blue: 153/255.0, alpha: 1.0)
            }
            
            cell.lblDate.text = arrAllDate[indexPath.row]
            cell.lblWeekDayName.text = arrAllWeekDayName[indexPath.row]
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCollCell", for: indexPath) as! PromoCollCell
            cell.viewDashed.layer.cornerRadius = 8
            cell.viewDashed.layer.masksToBounds = true
            
            let dictpromo = arrPromoList[indexPath.row] as! NSDictionary
            cell.lblPromo.text = dictpromo.valueForNullableKey(key: KitchenDescrition)
            cell.lblPromoTitle.text = dictpromo.valueForNullableKey(key: kCouponCode) + ": "
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView.tag == 101
        {
            return CGSize(width: collectionView.frame.width/8.5, height: 45)
        }
        else
        {
            return CGSize(width: collectionView.frame.width-50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 101
        {
            if self.isSelectedIndex == indexPath.row
            {
                self.isSelectedIndex = -1
            }
            else
            {
                self.isSelectedIndex = indexPath.row
            }
            strSelectedDay = arrAllWeekDayName[indexPath.row]
            if strSelectedDay == "Mon"
            {
                strSelectedDay = "1"
            }else if strSelectedDay == "Tue"{
                strSelectedDay = "2"
            }else if strSelectedDay == "Wed"{
                strSelectedDay = "3"
            }else if strSelectedDay == "Thu"{
                strSelectedDay = "4"
            }else if strSelectedDay == "Fri"{
                strSelectedDay = "5"
            }else if strSelectedDay == "Sat"{
                strSelectedDay = "6"
            }else if strSelectedDay == "Sun"{
                strSelectedDay = "7"
            }
            print("selectedDay...............", strSelectedDay)
            
            self.isSelectedIndex = indexPath.row
            
            if self.appDelegate.isInternetAvailable() == true
            {
                self.windowShowActivity(text: "")
                self.KitchenMethodApi()
            } else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 101
        {
            return self.arrKitchenList.count
        }
        else
        {
            return 1
        }
    }
    
    //MARK:- tableView Delegate and DataSource......................
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 101
        {
            if ((arrKitchenList.object(at: section) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).count > 0
            {
                return ((arrKitchenList.object(at: section) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).count
            }
            else
            {
                return 0
            }
        }
        else
        {
            print("tableView tag............", ((((arrKitchenList.object(at: customTblClass.sectionIndex) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray).count)
            
            if ((((arrKitchenList.object(at: customTblClass.sectionIndex) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray).count>0
            {
                return ((((arrKitchenList.object(at: customTblClass.sectionIndex) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray).count
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 101
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryNameTblCell", for: indexPath as IndexPath) as! CategoryNameTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            cell.tblCategory.register(UINib(nibName: "CategoryTblCell", bundle: nil), forCellReuseIdentifier: "CategoryTblCell")
            if ((arrKitchenList.object(at: indexPath.section) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).count > 0
            {
                let arrCategory = ((arrKitchenList.object(at: indexPath.section) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray)
                let dictCategoryMenu = arrCategory[indexPath.row] as! NSDictionary
                cell.lblCategoryName.text = "Category : \(dictCategoryMenu.valueForNullableKey(key: kCategoryName))"
            }
            
            cell.tblCategory.delegate = self
            cell.tblCategory.dataSource = self
            cell.tblCategory.tag = indexPath.row
            customTblClass.rowIndex = indexPath.row
            customTblClass.sectionIndex = indexPath.section
            cell.tblCategory.isScrollEnabled = false
            cell.tblCategory.alwaysBounceVertical = false
            
            cell.tblCategory.reloadData()
            
            return cell
        }
        else
        {
            let KitchenCell = tableView.dequeueReusableCell(withIdentifier: "CategoryTblCell", for: indexPath as IndexPath) as! CategoryTblCell
            KitchenCell.selectionStyle = .none
            KitchenCell.backgroundColor = .clear
            KitchenCell.imgMenu.layer.cornerRadius = 8
            KitchenCell.imgMenu.layer.masksToBounds = true
            KitchenCell.rowIndex = customTblClass.rowIndex
            KitchenCell.sectionIndex = customTblClass.sectionIndex
            
            let arrkitchenMenu = ((((arrKitchenList.object(at: customTblClass.sectionIndex) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray)
            if arrkitchenMenu.count>0
            {
                let dictKitchenMenu = arrkitchenMenu[indexPath.row] as! NSDictionary
                KitchenCell.lblMenuName.text = dictKitchenMenu.valueForNullableKey(key: kBreakfastTitle)
                KitchenCell.lblMenuDescription.text = dictKitchenMenu.valueForNullableKey(key: kBreakfastDescription)
                KitchenCell.lblPrice.text = "AED \(dictKitchenMenu.valueForNullableKey(key: kItemPrice))"
                //KitchenCell.lblDiscountedPrice.text = "AED \(dictKitchenData.valueForNullableKey(key: kItemDiscountedPrice))"
                KitchenCell.imgMenu.sd_addActivityIndicator()
                let url = URL.init(string: dictKitchenMenu.value(forKey: kIcon) as! String)
                KitchenCell.imgMenu.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    KitchenCell.imgMenu.sd_removeActivityIndicator()
                })
                
                if dictKitchenMenu.valueForNullableKey(key: kCartExist) == "0"
                {
                    KitchenCell.btnAddToCart.isHidden = true
                }else{
//                    if dictKitchenMenu.valueForNullableKey(key: kReplace) == "1"
//                    {
//                        KitchenCell.btnAddToCart.isHidden = true
//                    }
//                    else
//                    {
                        KitchenCell.btnAddToCart.isHidden = false
                   // }
                    
                }
            }
           
            KitchenCell.btnAddToCart.tagRowIndex = indexPath.row
            KitchenCell.btnAddToCart.tagSectionIndex = indexPath.section
          //  KitchenCell.btnAddToCart.isUserInteractionEnabled = false
            KitchenCell.btnAddToCart.addTarget(self, action: #selector(btnAddToCart(_:)), for: .touchUpInside)
            
            return KitchenCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 101
        {
            //return UITableView.automaticDimension
            if ((((arrKitchenList.object(at: indexPath.section) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray).count > 0
            {
                return (50 + CGFloat(((((arrKitchenList.object(at: indexPath.section) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray).count * 180))
            }
            else
            {
                return UITableView.automaticDimension
            }
        }
        else
        {
            return 180//UITableView.automaticDimension
            // return (225 + CGFloat(((((arrKitchenList.object(at: customTblClass.sectionIndex) as! NSDictionary).object(forKey: kKitchenCategory) as! NSArray).object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kCategoryMenu) as! NSArray).count * 180))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag == 101
        {
            
        }
        else
        {
            if isNavigationAddToCart == "AddToCart"
            {
                self.windowShowActivity(text: "")

                let dictKitchen = arrKitchenList.object(at: indexPath.section) as! NSDictionary
                    
                    //print(dictKitchen)
                    let arrCategory = dictKitchen.object(forKey: kKitchenCategory) as! NSArray
                let dictCategory = arrCategory[tableView.tag] as! NSDictionary
                    
                    //print(dictCategory)
                    let arrkitchenMenu = dictCategory.object(forKey: kCategoryMenu) as! NSArray
                    let dictKitchenMenu = arrkitchenMenu[indexPath.row] as! NSDictionary
                    
                    // print(dictKitchenMenu)
                    let dictCart = dictKitchenMenu.object(forKey: "cart") as! NSDictionary
                    var PlanID = ""
                    var PlanDay = ""
                    
                    if dictCart.count>0
                    {
                        PlanID = dictCart.valueForNullableKey(key: kPlanID)
                        PlanDay = dictCart.valueForNullableKey(key: kPlanDay)
                    }
                    
                    strCartExist = dictKitchenMenu.valueForNullableKey(key: kCartExist)
                    if strCartExist == "0"
                    {
                        let addCart = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                        addCart.strKitchenMenuID = dictKitchenMenu.valueForNullableKey(key: kId)
                        addCart.strKitchenFarmID = dictKitchen.valueForNullableKey(key: kKitchenID)
                        addCart.isNavigation = "MealsVC"
                        addCart.strKitchenName = dictKitchenData.valueForNullableKey(key: Kitchenname)
                        self.navigationController?.pushViewController(addCart, animated: true)
                    }
                    else
                    {
                        let dict = NSMutableDictionary()
                        dict.setValue(dictReplaceParameter.valueForNullableKey(key: kCartMenuId), forKey: kCartMenuId)
                        dict.setValue(dictReplaceParameter.valueForNullableKey(key: kCartId), forKey: kCartId)
                        dict.setObject(dictKitchenMenu.valueForNullableKey(key: kId), forKey: kKitchenMenuId as NSCopying)
                        dict.setObject(dictCategory.valueForNullableKey(key: kCategoryId), forKey: kKitchenCategoryId as NSCopying)
                        
                        getallApiResultwithPostTokenMethod(Details:dict, strMethodname: kMethodChangeMenuToCart) { (responseData, error) in
                            
                            DispatchQueue.main.async {
                                self.hideActivityFromWindow()
                                
                                if error == nil
                                {
                                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                                    {
                                        isNavigationAddToCart = ""
                                        self.onShowAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String)
                                         
                                    }
                                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseChange)
                                    {
                                        let alertView = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
                                        
                                        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                                            switch action.style{
                                            case .default:
                                                
                                                let strCartID = dictCart.valueForNullableKey(key: kCartId)
                                                
                                                if self.appDelegate.isInternetAvailable() == true{
                                                    self.windowShowActivity(text: "")
                                                    
                                                    self.performSelector(inBackground: #selector(self.MethodDeleteCartAPI(idx:)), with: strCartID)
                                                }else
                                                {
                                                    self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
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
            else
            {
                let cell  = tableView.cellForRow(at: indexPath) as? CategoryTblCell
                // let tab = cell?.tblCategory
                
               // print(tab)
                
                
                
                let dictKitchen = arrKitchenList.object(at: cell?.sectionIndex ?? 0) as! NSDictionary
                
                //print(dictKitchen)
                let arrCategory = dictKitchen.object(forKey: kKitchenCategory) as! NSArray
                let dictCategory = arrCategory[tableView.tag] as! NSDictionary
                
                //print(dictCategory)
                let arrkitchenMenu = dictCategory.object(forKey: kCategoryMenu) as! NSArray
                let dictKitchenMenu = arrkitchenMenu[indexPath.row] as! NSDictionary
                
                // print(dictKitchenMenu)
                let dictCart = dictKitchenMenu.object(forKey: "cart") as! NSDictionary
                var PlanID = ""
                var PlanDay = ""
                
                if dictCart.count>0
                {
                    PlanID = dictCart.valueForNullableKey(key: kPlanid)
                    PlanDay = dictCart.valueForNullableKey(key: kPlanDay)
                }
                
                strCartExist = dictKitchenMenu.valueForNullableKey(key: kCartExist)
//                if strCartExist == "0"
//                {
                    let addCart = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                    addCart.strKitchenMenuID = dictKitchenMenu.valueForNullableKey(key: kId)
                    addCart.strKitchenFarmID = dictKitchen.valueForNullableKey(key: kKitchenID)
                    addCart.isNavigation = "MealsVC"
                    addCart.strKitchenName = dictKitchenData.valueForNullableKey(key: Kitchenname)
                    self.navigationController?.pushViewController(addCart, animated: true)
              //  }
//                else
//                {
//                    let dict = NSMutableDictionary()
//                    dict.setObject(dictKitchen.valueForNullableKey(key: kKitchenID), forKey: kKitchenID as NSCopying)
//                    dict.setObject(dictCategory.valueForNullableKey(key: kCategoryId), forKey: kKitchenCategoryId as NSCopying)
//                    dict.setObject(dictKitchenMenu.valueForNullableKey(key: kId), forKey: kKitchenMenuId as NSCopying)
//                    dict.setObject(dictKitchenMenu.valueForNullableKey(key: kItemPrice), forKey: kPrice as NSCopying)
//                    dict.setObject("1", forKey: kQuantity as NSCopying)
//                    dict.setObject(PlanID, forKey: kPlanid as NSCopying)
//                    dict.setObject(PlanDay, forKey: kPlanDay as NSCopying)
//                    dict.setObject("1", forKey: kDays as NSCopying)
//
//                    getallApiResultwithPostTokenMethod(Details:dict, strMethodname: kMethodAddToCart) { (responseData, error) in
//
//                        DispatchQueue.main.async {
//                            self.hideActivityFromWindow()
//
//                            if error == nil
//                            {
//                                if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
//                                {
//                                    self.onShowAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String)
//                                    self.KitchenMethodApi()
//                                }
//                                else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseChange)
//                                {
//                                    let alertView = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
//
//                                    alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//                                        switch action.style{
//                                        case .default:
//
//                                            let strCartID = dictCart.valueForNullableKey(key: kCartId)
//
//                                            if self.appDelegate.isInternetAvailable() == true{
//                                                self.windowShowActivity(text: "")
//
//                                                self.performSelector(inBackground: #selector(self.MethodDeleteCartAPI(idx:)), with: strCartID)
//                                            }else
//                                            {
//                                                self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
//                                            }
//
//                                            break
//                                        case .cancel:
//
//                                            break
//                                        case .destructive:
//
//                                            break
//                                        }
//                                    }))
//                                    self.present(alertView, animated: true)
//
//                                }
//                                else
//                                {
//                                    self.onShowAlertController(title: kError, message: responseData?.object(forKey: kMessage) as? String)
//                                }
//                            }
//                            else
//                            {
//                                self.onShowAlertController(title: kError, message: "Having some issue.Please try again.")
//                            }
//                        }
//                    }
                //}
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView.tag == 101
        {
            let headerView = UIView()
            headerView.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
            headerView.backgroundColor = UIColor(red:242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
            
            let label : UILabel = UILabel(frame: CGRect(x: 15, y: 15, width: UIScreen.main.bounds.width, height: 18))
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.left
            label.font = UIFont.init(name: "POPPINS-BOLD", size: 15)
            label.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            label.text = (arrKitchenList[section] as! NSDictionary).value(forKey: Kitchenname) as? String
            headerTextCount = ((arrKitchenList[section] as! NSDictionary).value(forKey: Kitchenname) as? String)!
            
            if headerTextCount.count > 80
            {
                label.frame = CGRect(x: 15, y: 15, width: UIScreen.main.bounds.width-100, height: 50)
            }
            else
            {
                label.frame =  CGRect(x: 15, y: 15, width: UIScreen.main.bounds.width-100, height: 18)
            }
            headerView.addSubview(label)
            
            let btnKitchenMore : UIButton = UIButton(frame: CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width - 15, height: 18))
            btnKitchenMore.setTitle("More Detail", for: .normal)
            btnKitchenMore.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right// titleLabel?.textAlignment = .right
            btnKitchenMore.setTitleColor(UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0), for: .normal)
            btnKitchenMore.titleLabel?.font = UIFont.init(name: "POPPINS-BOLD", size: 15)
            
            btnKitchenMore.tag = section
            
            btnKitchenMore.addTarget(self, action: #selector(btnKitchenMoreDetail(_:)), for: .touchUpInside)
            headerView.addSubview(btnKitchenMore)
            
            return headerView
        }
        else
        {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView.tag == 101
        {
            headerTextCount = ((arrKitchenList[section] as! NSDictionary).value(forKey: Kitchenname) as? String)!
            if headerTextCount.count > 80
            {
                return 80
            }
            else
            {
                return 50
            }
        }
        else
        {
            return 0
        }
        
    }
    
    
    //MARK: Kitchen and Farm List API Integration.................
    func GetKitchenList()
    {
        self.view.endEditing(true)
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.KitchenMethodApi()
            //  self.performSelector(inBackground: #selector(self.KitchenMethodApi), with: nil)
            
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    func KitchenParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(appDelegate.StrVendortype, forKey: kVendorType as NSCopying)
        dict.setObject(txtSearch.text!, forKey: kSearchName as NSCopying)
        dict.setObject(appDelegate.SwitchType, forKey: kHumanType as NSCopying)
        
        if strRatingOrder != "" && strRatingOrder == "Rating high to low"
        {
            dict.setObject(kAsc, forKey: kRating as NSCopying)
        }
        else if strRatingOrder != "" && strRatingOrder == "Rating low to high"
        {
            dict.setObject(kDesc, forKey: kRating as NSCopying)
        }
        dict.setObject(strSelectedDay, forKey: kDay as NSCopying)
        dict.setObject(strGF, forKey: "gf" as NSCopying)
        dict.setObject(strSF, forKey: "sf" as NSCopying)
        dict.setObject(strDF, forKey: "df" as NSCopying)
        return dict
    }
    @objc func KitchenMethodApi()
    {
        getallApiResultwithPostTokenMethod(Details:KitchenParam(), strMethodname: kMethodKitchenListNew) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let kdata = (responseData?.value(forKey: kResponseDataDict) as! NSDictionary)
                        if kdata["total_cart"] != nil{
                            let cartValue = kdata["total_cart"] as? Int ?? 0
                            
                            cartValue > 0 ? (self.lblCartCount?.alpha = 1.0) : (self.lblCartCount?.alpha = 0.0)
                            self.lblCartCount?.text = "\(kdata["total_cart"] as? Int ?? 0)"
                            
                           
                        }
                        if self.appDelegate.StrVendortype == "Kitchen"
                        {
                            self.arrKitchenList = (kdata.object(forKey: kKitchenList) as! NSArray).mutableCopy() as! NSMutableArray
                            self.arrCategoryList = (self.arrKitchenList.value(forKey: kKitchenCategory) as! NSArray).mutableCopy() as! NSMutableArray
                            if self.arrKitchenList.count == 0
                            {
                                self.onShowAlertController(title: kError, message: "No menu is available please try some other day.")
                            }
                            if (kdata.object(forKey: kPromocodes) != nil)
                            {
                                self.arrPromoList = (kdata.object(forKey: kPromocodes) as! NSArray).mutableCopy() as! NSMutableArray
                            }
                            
                            self.tblKitchenList.reloadData()
                            self.CollViewPromo.reloadData()
                            self.CollViewCalender.reloadData()
                        }
                        else
                        {
                            self.arrKitchenList = (kdata.object(forKey: kFarmList) as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblKitchenList.reloadData()
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
    
    //MARK: - AddToCart API Intigartion...................
    func AddToCartParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        //        dict.setObject(strKitchenID, forKey: kKitchenID as NSCopying)
        //        dict.setObject(strKitchenCategoryID, forKey: kKitchenCategoryId as NSCopying)
        //        dict.setObject(strKitchenMenuID, forKey: kKitchenMenuId as NSCopying)
        //        dict.setObject(strTotalPrice, forKey: kPrice as NSCopying)
        //        dict.setObject(OrderModel.counterValue, forKey: kQuantity as NSCopying)
        //        dict.setObject(planID, forKey: kPlanid as NSCopying)
        //        dict.setObject(planday, forKey: kPlanDay as NSCopying)
        //        dict.setObject(self.strDayLeft, forKey: kDays as NSCopying)
        return dict
    }
    @objc func MethodAddToCartAPI()
    {
        getallApiResultwithPostTokenMethod(Details:AddToCartParam(), strMethodname: kMethodAddToCart) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
                        //NavCtrl.dictOrder = self.AddOrderParam()
                        self.navigationController?.pushViewController(NavCtrl, animated: true)
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
    
    //MARK: - Delete Cart API Intigartion...................
    @objc func MethodDeleteCartAPI(idx: String)
    {
        let DataDict = NSMutableDictionary()
        DataDict.setValue(idx, forKey: kKitchenMenuId)
        
        getallApiResultwithPostTokenMethod(Details:DataDict, strMethodname: kMethodDeleteCart) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        //                        if self.appDelegate.isInternetAvailable() == true{
                        //                            self.windowShowActivity(text: "")
                        //                            self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
                        //                        }else
                        //                        {
                        //                            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                        //                        }
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

//MARK:- Convert Date Format like dd/mm/yyy to d/m/yy
extension String {
    
    func convertDatetring_TopreferredFormat(currentFormat: String, toFormat : String) ->  String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = currentFormat
        let resultDate = dateFormator.date(from: self)
        dateFormator.dateFormat = toFormat
        return dateFormator.string(from: resultDate!)
    }
}


extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
}
