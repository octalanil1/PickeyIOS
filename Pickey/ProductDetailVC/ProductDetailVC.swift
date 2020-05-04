//
//  ProductDetailVC.swift
//  Pickey
//
//  Created by octal on 21/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import Stripe

class ProductDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource, FloatRatingViewDelegate, DataEnteredDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var CollView: UICollectionView!
    @IBOutlet weak var tbl_data:UITableView!
    @IBOutlet weak var btnPay:UIButton!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    //MARK:- variable and objects.............
    //Data show from kitchendetailvc
    var dictKitchen = NSDictionary()
    var dictMealMenu = NSDictionary()
    var arrItem = NSMutableArray()
    var arrplanTop = NSMutableArray()
    var arrTime = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    var strTotalPrice = ""
    var strKitchenID = ""
    var strKitchenCategoryID = ""
    var strDayLeft = ""
    var strKitchenName = ""
    //Data From MealVc
    var strKitchenFarmID = ""
    var strKitchenMenuID = ""
    var strSelectDropDownButton = ""
    var strSelectPlanButton = ""
    var strCouponcode = ""
    var strDeliveryNote = ""
    var IntDiscountPrice = 0.0
    var IntMinimumPriceForPromo = 0.0
    var isNavigation = ""
    var SelectNo:Int = 0
    var strTimeFrom = ""
    var strTimeTo = ""
    var isSelectTxtField : Bool = false
    var statusBarState = false
    var isSelectedWallet = false
    var strFinalPricePay = ""
    var strFinalWalletPrice = ""
    var isSelectedIndex = 0
    var isIndexSelected = false
    var intIndexSelectedPlan:Int = 0
    var planID = ""
    var planday = ""
    var strClickEvent = ""
    
    //MARK:- System Defined Methods....................
    override func viewDidLoad()
    {
        super.viewDidLoad()
        registercell()
        
       if isNavigationFrom == "isFromWelcomeVC" || isNavigationFrom == "isFromSkipNow"
       {
           let alert = UIAlertController(title: "", message: kUnAuthenticateUser, preferredStyle: .alert )
           let actionAllow = UIAlertAction(title: "Yes", style: .default) { alert in
            self.navigationController?.popViewController(animated: true)
           }
           alert.addAction(actionAllow)
           self.present(alert, animated: true, completion: nil)
       }
       else
       {
            if self.appDelegate.isInternetAvailable() == true{
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.KitchenMethodApi), with: nil)
            }else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return statusBarState
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        statusBarState = true
        UIView.animate(withDuration: 0.30) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        self.tbl_data.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- protocol Method used for Geting data back
    func userDidEnterInformation(info: NSDictionary) {
        strCouponcode = info.valueForNullableKey(key: kPromocodeName)
        
        IntDiscountPrice = Double(Float(info.valueForNullableKey(key: kDiscountValue))!)
        let  floatDiscountPrice = Float(IntDiscountPrice)
        
        let IntTotalPrice = info.value(forKey: KTotalAmount) as! Double
        let floatPrice = Float(IntTotalPrice)
        
        IntMinimumPriceForPromo = Double((floatPrice + floatDiscountPrice))
        
        self.tbl_data.reloadData()
    }
    
    func isNavigation(info: String)
    {
        isNavigation = info
    }
    
    @objc func methodBackBtnAction(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func methodAddCart(_ sender: UIButton!)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- UIButton Actions.........
    @IBAction func btnPayment(_ sender: UIButton)
    {
        if isIndexSelected == false
        {
            var yOffset = 0
            if (self.tbl_data.contentSize.height > self.tbl_data.bounds.height)
            {
                yOffset = Int(self.tbl_data.contentSize.height - self.tbl_data.bounds.height)
            }
            self.tbl_data.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            
        }
        else
        {
            strClickEvent = "AddToCart"
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
            // vc.dictOrder = AddOrderParam()
            vc.planId = self.planID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //        if isIndexSelected == false
        //        {
        //            var yOffset = 0
        //            if (self.tbl_data.contentSize.height > self.tbl_data.bounds.height)
        //            {
        //                yOffset = Int(self.tbl_data.contentSize.height - self.tbl_data.bounds.height)
        //            }
        //            self.tbl_data.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
        //
        //        }
        //        else
        //        {
        //            if self.checkValidation()
        //            {
        //                let intFromTime = Int(strTimeFrom)
        //                let intToTime = Int(strTimeTo)
        //                if intFromTime! > intToTime!
        //                {
        //                    onShowAlertController(title: kError, message: ValidationLarger)
        //                }
        //                else
        //                {
        //                    if strPayForWallet == true{
        //                        self.view.endEditing(true)
        //                        if self.appDelegate.isInternetAvailable() == true
        //                        {
        //                            self.windowShowActivity(text: "")
        //                            self.performSelector(inBackground: #selector(self.MethodAddOrderApi), with: nil)
        //
        //                        } else
        //                        {
        //                            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        //                        }
        //                    }
        //                    else
        //                    {
        //                        let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewCardVC") as! AddNewCardVC
        //                        vc.dictOrder = AddOrderParam()
        //                        self.navigationController?.pushViewController(vc, animated: true)
        //                    }
        //                }
        //            }
        //        }
    }
    
    @objc func ChoosePlan(_ sender:UIButton)
    {
        strClickEvent = "Quantity"
        let DictPlanList = self.arrplanTop.object(at: sender.tag) as! NSDictionary
        self.strTotalPrice = "\(DictPlanList.valueForNullableKey(key: kPrice))"
        if self.isSelectedIndex == sender.tag && self.isIndexSelected == true{
            self.isIndexSelected = false
            self.planID = ""
        }
        else
        {
            self.isIndexSelected = true
            self.planID = DictPlanList.valueForNullableKey(key: kId)
            self.planday = DictPlanList.valueForNullableKey(key: kPlan)
            
            let alertView = UIAlertController(title: "Please select the rest of the meals to complete your subscription plan?", message: "", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                switch action.style{
                case .default:
                    self.strDayLeft = "1"
                    if self.appDelegate.isInternetAvailable() == true{
                        self.windowShowActivity(text: "")
                        self.performSelector(inBackground: #selector(self.MethodAddToCartAPI), with: nil)
                    }else
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
                self.strDayLeft = self.planday
                if self.appDelegate.isInternetAvailable() == true{
                    self.windowShowActivity(text: "")
                    self.performSelector(inBackground: #selector(self.MethodAddToCartAPI), with: nil)
                }else
                {
                    self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                }
            })
            present(alertView, animated: true)
        }
        
        
        
        self.isSelectedIndex = sender.tag
        
        tbl_data.reloadData()
    }
    
    @objc func methodDropDownAction(_ sender: UIButton!)
    {
        if sender.tag == 0
        {
            strSelectDropDownButton = "HiddenCell"
            sender.setImage(UIImage(named: "down_arrow1"), for: .normal)
            sender.tag = 1
        }
        else
        {
            strSelectDropDownButton = "ShowCell"
            sender.tag = 0
            sender.setImage(UIImage(named: "up_arrow"), for: .normal)
        }
        tbl_data.reloadData()
    }
    
    @objc func SelectPlanDropDown(_ sender:UIButton)
    {
        if sender.tag == 0
        {
            strSelectPlanButton = "HidePlan"
            sender.tag = 1
            sender.setImage(UIImage(named: "down_arrow1"), for: .normal)
        }
        else
        {
            strSelectPlanButton = "ShowPlan"
            sender.tag = 0
            sender.setImage(UIImage(named: "up_arrow"), for: .normal)
        }
        tbl_data.reloadData()
    }
    
    @objc func MinusButton(_ sender:UIButton)
    {
        strClickEvent = "Quantity"
        if isIndexSelected == true
        {
            if OrderModel.counterValue > 1{
                
                OrderModel.counterValue = OrderModel.counterValue - 1
                if self.appDelegate.isInternetAvailable() == true{
                    self.windowShowActivity(text: "")
                    self.performSelector(inBackground: #selector(self.MethodAddToCartAPI), with: nil)
                }else
                {
                    self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                }
            }
        }
        else
        {
            self.onShowAlertController(title: "", message: "Please Select Plan")
        }
        
    }
    @objc func AddButton(_ sender:UIButton)
    {
        strClickEvent = "Quantity"
        if isIndexSelected == true
        {
            OrderModel.counterValue = OrderModel.counterValue + 1
            
            if self.appDelegate.isInternetAvailable() == true{
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.MethodAddToCartAPI), with: nil)
            }else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
        else
        {
            self.onShowAlertController(title: "", message: "Please Select Plan")
        }
    }
    
    @objc func btnApplyCode(_ sender:UIButton)
    {
        if isNavigation == "MealsVC"
        {
            if strCouponcode != ""
            {
                //                self.view.endEditing(true)
                //                if self.appDelegate.isInternetAvailable() == true
                //                {
                //                    self.windowShowActivity(text: "")
                //                    self.performSelector(inBackground: #selector(self.ApplyCodeApi), with: nil)
                //
                //                }else
                //                {
                //                    self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                //                }
            }
            else
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "PromoCodeVC") as! PromoCodeVC
                vc.delegate = self
                vc.strAmount = "\(OrderModel.TotalPriceCalculate)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            if sender.titleLabel?.text != "Apply Code"
            {
                sender.setTitle("Apply Code", for: .normal)
                self.strCouponcode = ""
                IntDiscountPrice = 0
                isNavigation = "MealsVC"
                tbl_data.reloadData()
            }
            else
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "PromoCodeVC") as! PromoCodeVC
                vc.delegate = self
                vc.strAmount = "\(OrderModel.TotalPriceCalculate)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func btnChangePayment(_ sender:UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnChangeAddress(_ sender:UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ManageAccountVC") as! ManageAccountVC
        vc.isNavigation = "ManageAccountVC"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnWallet(_ sender:UIButton)
    {
        if sender.isSelected == true
        {
            sender.isSelected = false
            isSelectedWallet = false
            print("Not Selected")
        }else{
            if dictKitchen.valueForNullableKey(key: kUserWalletAmount) == "0"{
                isSelectedWallet = false
                sender.isSelected = false
            }else{
                print("select Wallet Amount")
                isSelectedWallet = true
                sender.isSelected = true
            }
        }
        self.tbl_data.reloadData()
    }
    
    func registercell()
    {
        tbl_data.register(UINib(nibName: "HeaderKitchenCell", bundle: nil), forCellReuseIdentifier: "HeaderKitchenCell")
        tbl_data.register(UINib(nibName: "DishListCell", bundle: nil), forCellReuseIdentifier: "DishListCell")
        tbl_data.register(UINib(nibName: "ReviewstarCell", bundle: nil), forCellReuseIdentifier: "ReviewstarCell")
        tbl_data.register(UINib(nibName: "BenifitVC", bundle: nil), forCellReuseIdentifier: "BenifitVC")
        tbl_data.register(UINib(nibName: "QuantityVC", bundle: nil), forCellReuseIdentifier: "QuantityVC")
        tbl_data.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellReuseIdentifier: "SubscriptionCell")
        tbl_data.register(UINib(nibName: "SubscrptionListCell", bundle: nil), forCellReuseIdentifier: "SubscrptionListCell")
        tbl_data.register(UINib(nibName: "TimeTblCell", bundle: nil), forCellReuseIdentifier: "TimeTblCell")
        tbl_data.register(UINib(nibName: "PlanTblCell", bundle: nil), forCellReuseIdentifier: "PlanTblCell")
        tbl_data.register(UINib(nibName: "DateWisePlanTblCell", bundle: nil), forCellReuseIdentifier: "DateWisePlanTblCell")
    }
    
    //MARK:- UItextFeild Delegate Methods.......
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1
        {
            strCouponcode = textField.text!
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag == 3
        {
            self.view.endEditing(true)
            SelectNo = 1
            isSelectTxtField = true
        }
        if textField.tag == 4
        {
            self.view.endEditing(true)
            SelectNo = 2
            isSelectTxtField = true
        }
        tbl_data.reloadData()
    }
    
    
    //MARK:- textView Delegate and DataSource......................
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        strDeliveryNote = textView.text
    }
    
    //MARK:- tableView Delegate and DataSource......................
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 101
        {
            if section == 0
            {
                return 1
            }
            else if section == 1
            {
                return arrItem.count
            }
            else if section == 2
            {
                return 1
            }
            else if section == 3
            {
                return 1
            }
            else if section == 4
            {
                return 1
            }
            else if section == 5
            {
                return 1
            }
            else
            {
                return arrplanTop.count
            }
        }
        else {
            return self.arrTime.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderKitchenCell") as! HeaderKitchenCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if dictMealMenu.count>0
            {
                cell.lblFoodTitle.text = dictMealMenu.valueForNullableKey(key: kBreakfastTitle)
                let IntPrice = Double(strTotalPrice)
                cell.lblPrice.text = "AED \(Int(IntPrice!))"
                cell.lblFoodDescription.text = dictMealMenu.valueForNullableKey(key: kBreakfastDescription)
                cell.imgFood.sd_addActivityIndicator()
                let url = URL.init(string: dictMealMenu.valueForNullableKey(key: kIcon))
                cell.imgFood.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell.imgFood.sd_removeActivityIndicator()
                })
            }
            cell.btnDropDown.addTarget(self, action: #selector(methodDropDownAction(_:)), for: .touchUpInside)
            cell.btnBack.addTarget(self, action: #selector(methodBackBtnAction(_:)), for: .touchUpInside)
            //cell.btnCart.alpha = 0.0
            cell.btnCart.addTarget(self, action: #selector(methodAddCart(_:)), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishListCell") as! DishListCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if arrItem.count>0
            {
                let ItemList = self.arrItem.object(at: indexPath.row) as! NSDictionary
                cell.lblFoodTitle.text = ItemList.valueForNullableKey(key: kItemName)
                cell.lblFoodTitle.text = ItemList.valueForNullableKey(key: kItemName)
                cell.lblDescription.text = ItemList.valueForNullableKey(key: kItemDescription)
                
                let url = URL.init(string: ItemList.valueForNullableKey(key: kItemIcon))
                cell.imgRestaurant.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                    cell.imgRestaurant.sd_removeActivityIndicator()
                })
            }
            
            if strSelectDropDownButton == "HiddenCell"{
                cell.ViewcontentDish.isHidden = true
            }else{
                cell.ViewcontentDish.isHidden = false
            }
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewstarCell") as! ReviewstarCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.viewRating?.delegate = self
            cell.viewRating?.backgroundColor = UIColor.clear
            cell.viewRating?.contentMode = UIView.ContentMode.scaleAspectFit
            cell.viewRating?.type = .halfRatings
            cell.viewRating?.editable = false
            
            if dictKitchen.count>0
            {
                cell.viewRating = dictKitchen.value(forKey: KitchenRating) as? FloatRatingView
                if dictKitchen.valueForNullableKey(key: kReviews) == ""
                {
                    cell.lblRate.text = "0 Reviews"
                }
                else{
                    cell.lblRate.text = dictKitchen.valueForNullableKey(key: kReviews) + " Reviews"
                }
            }
            
            let strSF = dictMealMenu.valueForNullableKey(key: "sf")
            let strDF = dictMealMenu.valueForNullableKey(key: "df")
            let strGF = dictMealMenu.valueForNullableKey(key: "gf")
            if strSF == "0" || strSF == ""
            {
                cell.SFImg.image = UIImage.init(named: "gf")
            }
            else{
                cell.SFImg.image = UIImage.init(named: "gf_1")
            }
            if strDF == "0" || strDF == ""
            {
                cell.DFImg.image = UIImage.init(named: "gf")
            }
            else{
                cell.DFImg.image = UIImage.init(named: "gf_1")
            }
            if strGF == "0" || strGF == ""
            {
                cell.GFImg.image = UIImage.init(named: "gf")
            }
            else{
                cell.GFImg.image = UIImage.init(named: "gf_1")
            }
            if strSelectDropDownButton == "HiddenCell"
            {
                cell.ViewcontentReview.isHidden = true
            }
            else
            {
                cell.ViewcontentReview.isHidden = false
            }
            return cell
        }
        else if indexPath.section == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BenifitVC") as! BenifitVC
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            //                cell.tblTimesSlot.layer.borderWidth = 0.5
            //                cell.tblTimesSlot.layer.borderColor = UIColor.lightGray.cgColor
            
            if strSelectDropDownButton == "HiddenCell"{
                cell.Viewcontent.isHidden = true
            }else{
                cell.Viewcontent.isHidden = false
            }
            //                cell.tblTimesSlot.delegate = self
            //                cell.tblTimesSlot.dataSource = self
            //                cell.tblTimesSlot.register(UINib(nibName: "TimeTblCell", bundle: nil), forCellReuseIdentifier: "TimeTblCell")
            //                cell.txtFrom.delegate = self
            //                cell.txtTo.delegate = self
            //                cell.txtFrom.tag = 3
            //                cell.txtTo.tag = 4
            //                cell.txtFrom.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .touchUpInside)
            //                cell.txtTo.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .touchUpInside)
            //                cell.txtFrom.text = strTimeFrom
            //                cell.txtTo.text = strTimeTo
            
            //                if isSelectTxtField == false
            //                {
            cell.tblTimesSlot.isHidden = true
            //                }
            //                else
            //                {
            //                    cell.tblTimesSlot.isHidden = false
            //                }
            
            if dictMealMenu.count>0
            {
                if dictMealMenu.valueForNullableKey(key: KBone) == "0" || dictMealMenu.valueForNullableKey(key: KBone) == ""
                {
                    cell.viewBone.layer.borderColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).cgColor
                }
                else{
                    cell.viewBone.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
                }
                if dictMealMenu.valueForNullableKey(key: KBrain) == "0" || dictMealMenu.valueForNullableKey(key: KBrain) == ""
                {
                    cell.viewBrain.layer.borderColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).cgColor
                }
                else{
                    cell.viewBrain.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
                }
                if dictMealMenu.valueForNullableKey(key: KImmunity) == "0" || dictMealMenu.valueForNullableKey(key: KImmunity) == ""
                {
                    cell.viewImmunity.layer.borderColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).cgColor
                }else{
                    cell.viewImmunity.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
                }
            }
            return cell
        }
        else  if indexPath.section == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityVC") as! QuantityVC
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            if dictKitchen.count>0
            {
                if dictMealMenu.count>0
                {
                    let intTotalPrice = Double(strTotalPrice)
                    cell.lblQuantityPrice.text = "AED \((Int(intTotalPrice!) * OrderModel.counterValue))"
                    cell.lblNumberOfOrder.text = String(OrderModel.counterValue)
                    cell.lblQuantity.text = "AED \(self.strTotalPrice) x \(OrderModel.counterValue)"
                }
                if isIndexSelected == false
                {
                    btnPay.setTitle("Choose Plan", for: .normal)
                }
                else{
                    btnPay.setTitle("Add To Cart", for: .normal)
                }
            }
            
            cell.btnMinus.tag = indexPath.row
            cell.btnMinus.addTarget(self, action: #selector(MinusButton(_:)), for: .touchUpInside)
            cell.btnPlus.tag = indexPath.row
            cell.btnPlus.addTarget(self, action: #selector(AddButton(_:)), for: .touchUpInside)
            return cell
        }
        else if indexPath.section == 5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as! SubscriptionCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.btnSubscriptionDropDown.addTarget(self, action: #selector(SelectPlanDropDown(_:)), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscrptionListCell") as! SubscrptionListCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            let dictplan = self.arrplanTop.object(at: indexPath.row) as! NSDictionary
            cell.lblDays.text = String(format: "%@ Day", arguments:[dictplan.valueForNullableKey(key:kPlan)])
            cell.lblPrice.text = String(format: "%@/Meals", arguments:[dictplan.valueForNullableKey(key:kPrice)])
            intIndexSelectedPlan = indexPath.row
            cell.btnChoosePlan.tag = intIndexSelectedPlan
            
            // if dictMealMenu.valueForNullableKey(key: kCartExist) == "0"
            // {
            //    cell.btnChoosePlan.isUserInteractionEnabled = false
            // }
            //  else
            //   {
            cell.btnChoosePlan.isUserInteractionEnabled = true
            if self.isSelectedIndex == indexPath.row && self.isIndexSelected == true
            {
                cell.btnChoosePlan.setTitle("Choosed", for: .normal)
            }
            else
            {
                cell.btnChoosePlan.setTitle("Choose", for: .normal)
            }
            
            if strSelectPlanButton == "HidePlan"
            {
                cell.ViewcontentSubplan.isHidden = true
            }
            else
            {
                cell.ViewcontentSubplan.isHidden = false
            }
            
            cell.btnChoosePlan.addTarget(self, action: #selector(ChoosePlan(_:)), for: .touchUpInside)
            //   }
            
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 101
        {
            if indexPath.section == 0//headercell
            {
                return UITableView.automaticDimension
            }
            else if indexPath.section == 1 // dishlistcell
            {
                if strSelectDropDownButton == "HiddenCell"
                {
                    return 0
                }
                else
                {
                    return UITableView.automaticDimension
                }
            }
            else if indexPath.section == 2// reviewstarcell
            {
                if strSelectDropDownButton == "HiddenCell"
                {
                    return 0
                }
                else
                {
                    return 60
                }
            }
                
            else if indexPath.section == 3
            {// BenifitTblCell
                if strSelectDropDownButton == "HiddenCell"
                {
                    return 0
                }
                else
                {
                    return 80
                }
            }
            else if indexPath.section == 4 //QuantityCell
            {
                return UITableView.automaticDimension
            }
            else if indexPath.section == 4 //SubscriptionCell
            {
                return 67
            }
            else //SubscrptionListCell
            {
                return 78
            }
        }
        else
        {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 102
        {
            self.view.endEditing(true)
            let p = arrTime[indexPath.row]
            
            if SelectNo == 1
            {
                strTimeFrom = p
                //tableView.isHidden = true
                isSelectTxtField = false
            }
            if SelectNo == 2
            {
                strTimeTo = p
                //tableView.isHidden = true
                isSelectTxtField = false
            }
            tbl_data.reloadData()
        }
    }
    
    //MARK: - KitchenMenuByDayParam API Intigartion...................
    func AddToCartParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(strKitchenID, forKey: kKitchenID as NSCopying)
        dict.setObject(strKitchenCategoryID, forKey: kKitchenCategoryId as NSCopying)
        dict.setObject(strKitchenMenuID, forKey: kKitchenMenuId as NSCopying)
        dict.setObject(strTotalPrice, forKey: kPrice as NSCopying)
        dict.setObject(OrderModel.counterValue, forKey: kQuantity as NSCopying)
        dict.setObject(planID, forKey: kPlanid as NSCopying)
        dict.setObject(planday, forKey: kPlanDay as NSCopying)
        dict.setObject(self.strDayLeft, forKey: kDays as NSCopying)
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
                        if self.strClickEvent == "AddToCart"
                        {
                            let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
                            NavCtrl.dictOrder = self.AddOrderParam()
                            self.navigationController?.pushViewController(NavCtrl, animated: true)
                        }
                        else
                        {
                            self.onShowAlertController(title: kError, message: responseData?.object(forKey: kMessage) as? String)
                            self.appDelegate.showtabbar()
                            //self.tbl_data.reloadData()
                        }
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseChange)
                    {
                        
                        let alertView = UIAlertController(title: responseData?.object(forKey: kMessage) as? String, message: "You have already item in your cart of another category, kindaly complete your cart order with same category otherwise discard your cart.", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                //let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
                                //self.navigationController?.pushViewController(NavCtrl, animated: true)
                                self.appDelegate.showtabbar()
                                break
                            case .cancel:
                                
                                break
                            case .destructive:
                                
                                break
                            }
                        }))
                        alertView.addAction(UIAlertAction(title: "Discard", style: .cancel) { action in
                            let strCartID = responseData!.valueForNullableKey(key: kCartId)
                            if self.appDelegate.isInternetAvailable() == true{
                                self.windowShowActivity(text: "")
                                self.performSelector(inBackground: #selector(self.MethodDeleteCartAPI(idx:)), with: strCartID)
                            }else{
                                self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
                            }
                            print("Action: DFU resumed")
                        })
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
    
    //MARK: - KitchenDetail API Intigartion...................
    func KitchenDetailParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(strKitchenMenuID, forKey: kProviderID as NSCopying)
        //Adult
        dict.setObject(self.appDelegate.SwitchType, forKey: kHumanType as NSCopying)
        return dict
    }
    @objc func KitchenMethodApi()
    {
        getallApiResultwithPostTokenMethod(Details:KitchenDetailParam(), strMethodname: kMethodKitchenDetail) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        self.dictKitchen = data.object(forKey: kKitchenList) as! NSDictionary
                        self.dictMealMenu = self.dictKitchen.object(forKey: kKitchenMenu) as! NSDictionary
                        self.arrItem = (self.dictMealMenu.object(forKey: KItems) as! NSArray).mutableCopy() as! NSMutableArray
                        if self.dictMealMenu.object(forKey: kMenu_plans) != nil
                        {
                            self.arrplanTop = (self.dictMealMenu.object(forKey: kMenu_plans) as! NSArray).mutableCopy() as! NSMutableArray
                        }
                        self.strKitchenID = self.dictKitchen.valueForNullableKey(key: kKitchenID)
                        self.strKitchenCategoryID = self.dictMealMenu.valueForNullableKey(key: kKitchenCategoryId)
                        self.strDayLeft = self.dictMealMenu.valueForNullableKey(key: kDayLeft)
                        self.strTotalPrice = self.dictMealMenu.valueForNullableKey(key: kItemPrice)
                        if self.isIndexSelected == false
                        {
                            self.btnPay.setTitle("Choose Plan", for: .normal)
                        }
                        else{
                            self.btnPay.setTitle("Pay AED \(self.strTotalPrice)", for: .normal)
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
    
    func AddOrderParam() -> NSMutableDictionary
    {
        let DataPassDict = NSMutableDictionary()
        DataPassDict.setValue(self.strKitchenID, forKey: kKitchenID)
        DataPassDict.setValue(strKitchenMenuID, forKey: kKitchenMenuId)
        DataPassDict.setValue(dictKitchen.valueForNullableKey(key: kUserAddressID), forKey: kAddressId)
        DataPassDict.setValue(IntDiscountPrice, forKey: kPromoCode)
        if isSelectedWallet == true{
            DataPassDict.setValue("", forKey: kPaymentToken)
            DataPassDict.setValue(strFinalWalletPrice, forKey: kWalletAmount)
        }else{
            DataPassDict.setValue("", forKey: kWalletAmount)
        }
        DataPassDict.setValue(strFinalPricePay, forKey: kAmount) //OrderModel.TotalPriceCalculate
        DataPassDict.setValue("", forKey: kDeliveryFee)
        DataPassDict.setValue(strDeliveryNote, forKey: kSpcialNote)
        DataPassDict.setValue(strTimeFrom, forKey: kDeliveryTimeFrom)
        DataPassDict.setValue(strTimeTo, forKey: kDeliveryTimeTo)
        if strSelectFormattedString == ""{
            strSelectFormattedString = self.appDelegate.formattedDate.convertDatetring_TopreferredFormat(currentFormat: "EEEE-yyyy-mm-dd", toFormat: "YYYY-MM-dd")
            DataPassDict.setValue(strSelectFormattedString, forKey: kDates)
        }else{
            DataPassDict.setValue(strSelectFormattedString, forKey: kDates)
        }
        DataPassDict.setValue(OrderModel.counterValue, forKey: kQty)
        DataPassDict.setValue(strTotalPrice, forKey: kMenuAmount)
        
        return DataPassDict
    }
    @objc func MethodAddOrderApi()
    {
        getallApiResultwithPostTokenMethod(Details:AddOrderParam(), strMethodname: kMethodAddOrder) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        let strOrderId = data.valueForNullableKey(key: kId)
                        let alertView = UIAlertController(title: "", message: responseData?.object(forKey: kMessage) as? String, preferredStyle: .alert)
                        
                        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                
                                let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaceVC") as! OrderPlaceVC
                                NavCtrl.strOrderID = strOrderId
                                self.navigationController?.pushViewController(NavCtrl, animated: true)
                                
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
    //MARK: - Delete Cart API Intigartion...................
    @objc func MethodDeleteCartAPI(idx: String)
    {
        let DataDict = NSMutableDictionary()
        DataDict.setValue(idx, forKey: kCartId)
        
        getallApiResultwithPostTokenMethod(Details:DataDict, strMethodname: kMethodDeleteCart) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        //                            if self.appDelegate.isInternetAvailable() == true{
                        //                                self.windowShowActivity(text: "")
                        //                                self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
                        //                            }else
                        //                            {
                        //                                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                        //                            }
                        self.appDelegate.showtabbar()
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
