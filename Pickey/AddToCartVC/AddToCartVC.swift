    //
    //  AddToCartVC.swift
    //  Pickey
    //
    //  Created by Sunil Pradhan on 05/02/20.
    //  Copyright © 2020 Sunil Pradhan. All rights reserved.
    //
    
    import UIKit
    
    class AddToCartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DataEnteredDelegate, UITextFieldDelegate, UITextViewDelegate {
        
        @IBOutlet weak var lblNoDataFound: UILabel!
        @IBOutlet weak var tblView: UITableView!
        @IBOutlet weak var btnPay: UIButton!
        
        var arrCartItem = NSMutableArray()
        var dictCart = NSDictionary()
        var dictOrder = NSDictionary()
        var isNavigation = ""
        var strCouponcode = ""
        var strDeliveryNote = ""
        var IntDiscountPrice = 0.0
        var IntMinimumPriceForPromo = 0.0
        var strTotalAmount = ""
        var TotalPriceCalculate = 0.0
        var strMenuPrice = ""
        var strQuantity = 1
        var strMenuID = ""
        var strCartID = ""
        var planId = ""
        var strUsedWalletPrice = ""
        var strFinalPricePay = ""
        var strPayForWallet = false
        var isSelectedWallet = false
        var SelectNo:Int = 0
        var isSelectTxtField : Bool = false
        var strTimeFrom = ""
        var strTimeTo = ""
        var arrTime = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
        
        var customTblClass = customTable()
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
        }
        
        override func viewWillAppear(_ animated: Bool)
        {
            isNavigationAddToCart = ""
            //  dictReplaceParameter:NSDictionary() = nil
            
            self.lblNoDataFound.isHidden = true
            
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Cart", leftbuttonImageName: "", RightbuttonName: "")
            let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
            
            if self.appDelegate.isInternetAvailable() == true{
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
            }else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            self.tabBarController?.tabBar.isHidden = false
        }
        
        @IBAction func btnPay(_ sender: UIButton)
        {
            if self.checkValidation()
            {
                let intFromTime = Int(strTimeFrom)
                let intToTime = Int(strTimeTo)
                if intFromTime! > intToTime!
                {
                    onShowAlertController(title: kError, message: ValidationLarger)
                }
                else
                {
                    // if strPayForWallet == true{
                    self.view.endEditing(true)
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.windowShowActivity(text: "")
                        self.performSelector(inBackground: #selector(self.MethodAddOrderApi), with: nil)
                        
                    } else
                    {
                        self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                    }
                    //                   ¸
                }
            }
        }
        
        @objc func methodMenu(_ sender: UIButton!)
        {
            self.navigationController?.popViewController(animated: true)
        }
        
        @objc func methodBtnChangeAddress(_ sender: UIButton!)
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ManageAccountVC") as! ManageAccountVC
            vc.isNavigation = "ManageAccountVC"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func btnChangePayment(_ sender:UIButton)
        {
            //let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            //self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func userDidEnterInformation(info: NSDictionary) {
            strCouponcode = info.valueForNullableKey(key: kPromocodeName)
            
            IntDiscountPrice = Double(Float(info.valueForNullableKey(key: kDiscountValue))!)
            let  floatDiscountPrice = Float(IntDiscountPrice)
            
            let IntTotalPrice = info.value(forKey: KTotalAmount) as! Double
            let floatPrice = Float(IntTotalPrice)
            
            //IntMinimumPriceForPromo = Double((floatPrice + floatDiscountPrice))
            
            tblView.reloadData()
        }
        
        func isNavigation(info: String) {
            isNavigation = info
        }
        
        @objc func btnMinus(_ sender:UIButton)
        {
            let dictCart = arrCartItem[sender.tag] as! NSDictionary
            strMenuID = dictCart.valueForNullableKey(key: kKitchenMenuId)
            strMenuPrice = dictCart.valueForNullableKey(key: kPrice)
            planId = dictCart.valueForNullableKey(key: kPlanid)
            let Intprice = dictCart.valueForNullableKey(key: kQuantity)
            strQuantity = Int(Intprice)!
            
            if strQuantity > 1{
                
                strQuantity = strQuantity - 1
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                
                if self.strTotalAmount != ""
                {
                    if strCouponcode != ""
                    {
                        let intTotalPrice = Double(strTotalAmount)
                        ///if Int(IntMinimumPriceForPromo) >= (Int(intTotalPrice!) * strQuantity)
                        //{
                        sender.setTitle("Apply Code", for: .normal)
                        self.strCouponcode = ""
                        IntDiscountPrice = 0
                        isNavigation = "MealsVC"
                        tblView.reloadData()
                        // }
                    }
                }
                changeCartValue(quantity: strQuantity, idx: strMenuID, price: strMenuPrice, planId: planId)
            }
        }
        @objc func btnAdd(_ sender:UIButton)
        {
            let dictCart = arrCartItem[sender.tag] as! NSDictionary
            let Intprice = dictCart.valueForNullableKey(key: kQuantity)
            planId = dictCart.valueForNullableKey(key: kPlanid)
            strQuantity = Int(Intprice)!
            strQuantity = strQuantity + 1
            
            strMenuID = dictCart.valueForNullableKey(key: kKitchenMenuId)
            strMenuPrice = dictCart.valueForNullableKey(key: kPrice)
            changeCartValue(quantity: strQuantity, idx: strMenuID, price: strMenuPrice, planId: planId)
        }
        
        @objc func btnDelete(_ sender:UIButton)
        {
            //let arrCartMenu = ((arrCartItem[customTblClass.rowIndex] as! NSDictionary).value(forKey: kPlanMenus) as! NSArray)
            let dictCart = arrCartItem[sender.tag] as! NSDictionary
            strCartID = dictCart.valueForNullableKey(key: kCartId)
            
            if self.appDelegate.isInternetAvailable() == true{
                self.windowShowActivity(text: "")
                
                self.performSelector(inBackground: #selector(self.MethodDeleteCartAPI(idx:)), with: strCartID)
            }else
            {
                self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
            }
        }
        
        @objc func btnReplace(_ sender:ShadowButton)
        {
            
            let dictData = self.arrCartItem.object(at: sender.tagSectionIndex) as! NSDictionary
            let dictD = (dictData.object(forKey: "plan_menus") as! NSArray).object(at: sender.tagRowIndex) as! NSDictionary
            let cart_id = dictData.object(forKey: "cart_id") as? String ?? "0"
            let kitchen_id = dictData.object(forKey: "kitchen_id") as? String ?? "0"
            let kitchen_category_id = dictData.object(forKey: "kitchen_category_id") as? String ?? "0"
            let kitchen_menu_id = dictD.object(forKey: "kitchen_menu_id") as? String ?? "0"
            var request_type = "1"
            
            if dictD.object(forKey: "is_replace") as? Int ?? 0 == 1
            {
                request_type = "2"
            }
            let dict = ["cart_id":cart_id, "kitchen_id":kitchen_id,"kitchen_category_id":kitchen_category_id,"kitchen_menu_id":kitchen_menu_id,"request_type":request_type]
            
            
            self.showDoubleButtonAlert(title: kAppName, message: "Would you like to replace this item?", action1: "NO", action2: "YES", completion1: {
                
                
            }) {
                
                if self.appDelegate.isInternetAvailable() == true{
                    self.windowShowActivity(text: "")
                    self.performSelector(inBackground: #selector(self.methodReplaceItem(dataDict:)), with: dict)
                }else
                {
                    self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
                }
                
            }
            //           @Header("token") token: String?,
            //                      @Field("cart_id") cart_id: String?,
            //                      @Field("kitchen_id") kitchen_id: String?,
            //                      @Field("kitchen_category_id") kitchen_category_id: String?,
            //                      @Field("kitchen_menu_id") kitchen_menu_id: String?,
            //                      @Field("request_type") request_type: String?
            
            
            //            let arrCartMenu = ((arrCartItem[customTblClass.rowIndex] as! NSDictionary).value(forKey: kPlanMenus) as! NSArray)
            //            let dictCart = arrCartMenu[sender.tag] as! NSDictionary
            //
            //            let dict = arrCartItem[sender.tag] as! NSDictionary
            //
            //            strCartID = dict.valueForNullableKey(key: kCartId)
            //
            //            dictReplaceParameter.setValue(dict.valueForNullableKey(key: kCartId), forKey: kCartId)
            //            dictReplaceParameter.setValue(dict.valueForNullableKey(key: kKitchenCategoryId), forKey: kKitchenCategoryId)
            //            dictReplaceParameter.setValue(dictCart.valueForNullableKey(key: kCartMenuId), forKey: kCartMenuId)
            //            dictReplaceParameter.setValue(dictCart.valueForNullableKey(key: kKitchenMenuId), forKey: kKitchenMenuId)
            //            dictReplaceParameter.setValue("AddToCart", forKey: "IsFrom")
            //            isNavigationAddToCart = "AddToCart"
            //            self.appDelegate.showtabbar()
            //
            //            NotificationCenter.default.post(name: Notification.Name("ReplaceOrder"), object: dictReplaceParameter)
        }
        
        
        func changeCartValue(quantity: Int, idx: String, price: String, planId: String)
        {
            let dict = NSMutableDictionary.init()
            dict.setObject("\(quantity)", forKey: kQuantity as NSCopying)
            dict.setObject("\(idx)", forKey: kKitchenMenuId as NSCopying)
            dict.setObject("\(price)", forKey: kPrice as NSCopying)
            dict.setObject("\(planId)", forKey: kPlanid as NSCopying)
            
            if self.appDelegate.isInternetAvailable() == true{
                self.windowShowActivity(text: "")
                
                self.performSelector(inBackground: #selector(self.MethodAddToCartAPI(dictCartDetail:)), with: dict)
            }else
            {
                self.onShowAlertController(title:kNoInternetConnection , message: kInternetError)
            }
        }
        
        @objc func btnApplyCode(_ sender:UIButton)
        {
            if isNavigation == "MealsVC"
            {
                if strCouponcode != ""
                {
                    self.view.endEditing(true)
                    if self.appDelegate.isInternetAvailable() == true
                    {
                        self.windowShowActivity(text: "")
                        self.performSelector(inBackground: #selector(self.ApplyCodeApi), with: nil)
                        
                    }else
                    {
                        self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                    }
                }
                else
                {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "PromoCodeVC") as! PromoCodeVC
                    vc.delegate = self
                    vc.strAmount = dictCart.valueForNullableKey(key: KTotal)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                if sender.titleLabel?.text != "Apply Code"
                {
                    sender.setTitle("Apply Code", for: .normal)
                    self.strCouponcode = ""
                    let intTotalPrice = Double(strTotalAmount)
                    strTotalAmount = "\(IntDiscountPrice + intTotalPrice!)"
                    IntDiscountPrice = 0
                    isNavigation = "MealsVC"
                    tblView.reloadData()
                }
                else
                {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "PromoCodeVC") as! PromoCodeVC
                    vc.delegate = self
                    vc.strAmount = dictCart.valueForNullableKey(key: KTotal)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        @objc func btnWallet(_ sender:UIButton)
        {
            if sender.isSelected == true
            {
                sender.isSelected = false
                isSelectedWallet = false
                print("Not Selected")
            }else{
                if dictCart.valueForNullableKey(key: kWalletAmount) == "0"{
                    isSelectedWallet = false
                    sender.isSelected = false
                }else{
                    print("select Wallet Amount")
                    isSelectedWallet = true
                    sender.isSelected = true
                }
            }
            self.tblView.reloadData()
        }
        
        //MARK:- textField Delegate......................
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
            tblView.reloadData()
        }
        
        //MARK:- textView Delegate......................
        func textViewDidChangeSelection(_ textView: UITextView) {
            strDeliveryNote = textView.text
        }
        
        //MARK:- tableView Delegate and DataSource......................
        func numberOfSections(in tableView: UITableView) -> Int
        {
            if tableView.tag == 101{
                return 3
            }else if tableView.tag == 102{
                return 1
            }else{
                return 1
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.tag == 101
            {
                if section == 0{
                    return 1
                }else if section == 1{
                    return arrCartItem.count
                }else{
                    return 1
                }
            }else if tableView.tag == 102{
                return self.arrTime.count
            }else{
                return ((arrCartItem[customTblClass.rowIndex] as! NSDictionary).value(forKey: kPlanMenus) as! NSArray).count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            if tableView.tag == 101
            {
                if indexPath.section == 0
                {
                    let indentifier:String = "DeliveryAddressTblCell"
                    var cell : DeliveryAddressTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? DeliveryAddressTblCell
                    
                    if (cell == nil)
                    {
                        let nib:Array = Bundle.main.loadNibNamed("DeliveryAddressTblCell", owner: nil, options: nil)! as [Any]
                        cell = nib[0] as? DeliveryAddressTblCell
                        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                        cell?.backgroundColor = (UIColor.clear)
                    }
                    cell?.lblAddress.text = StrLandMark + ", " + StraddressString
                    cell?.btnChangeAddress.addTarget(self, action: #selector(methodBtnChangeAddress(_:)), for: .touchUpInside)
                    return cell!
                }
                else if indexPath.section == 1
                {
                    let indentifier:String = "CartCategoryTblCell"
                    var cell : CartCategoryTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? CartCategoryTblCell
                    
                    if (cell == nil)
                    {
                        let nib:Array = Bundle.main.loadNibNamed("CartCategoryTblCell", owner: nil, options: nil)! as [Any]
                        cell = nib[0] as? CartCategoryTblCell
                        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                        cell?.backgroundColor = (UIColor.clear)
                    }
                    cell?.selectionStyle = .none
                    
                    cell?.tblCart.register(UINib(nibName: "OrderFromTblCell", bundle: nil), forCellReuseIdentifier: "OrderFromTblCell")
                    cell?.btnDeletePlan.addTarget(self, action: #selector(btnDelete(_:)), for: .touchUpInside)
                    if arrCartItem.count > 0
                    {
                        let arrCategory = arrCartItem[indexPath.row] as! NSDictionary
                        cell?.lblKitchenName.text = arrCategory.valueForNullableKey(key: Kitchenname)
                        cell?.lblCategoryName.text = "Category : \(arrCategory.valueForNullableKey(key: kKitchenCategoryName))"
                    }
                    cell?.tblCart.delegate = self
                    cell?.tblCart.dataSource = self
                    cell?.tblCart.tag = indexPath.row
                    customTblClass.rowIndex = indexPath.row
                    cell?.tblCart.isScrollEnabled = false
                    cell?.tblCart.alwaysBounceVertical = false
                    
                    // customTblClass.sectionIndex = indexPath.section
                    cell?.tblCart.reloadData()
                    
                    return cell!
                }
                else
                {
                    let indentifier:String = "PaymentOptionTblCell"
                    var cell : PaymentOptionTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? PaymentOptionTblCell
                    
                    if (cell == nil)
                    {
                        let nib:Array = Bundle.main.loadNibNamed("PaymentOptionTblCell", owner: nil, options: nil)! as [Any]
                        cell = nib[0] as? PaymentOptionTblCell
                        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                        cell?.backgroundColor = (UIColor.clear)
                    }
                    
                    addInputAccessoryForTextFields(textFields: [cell!.txtPromoCode], dismissable: true, previousNextable: true)
                    addInputAccessoryForTextView(textViews: [cell!.txtDeliveryNote], dismissable: true, previousNextable: true)
                    cell!.txtDeliveryNote.delegate = self
                    cell!.txtDeliveryNote.text = strDeliveryNote
                    
                    cell?.tblTimeSlot.layer.borderWidth = 0.5
                    cell?.tblTimeSlot.layer.borderColor = UIColor.lightGray.cgColor
                    
                    cell?.tblTimeSlot.delegate = self
                    cell?.tblTimeSlot.dataSource = self
                    cell?.tblTimeSlot.register(UINib(nibName: "TimeTblCell", bundle: nil), forCellReuseIdentifier: "TimeTblCell")
                    cell?.txtFrom.delegate = self
                    cell?.txtTo.delegate = self
                    cell?.txtFrom.tag = 3
                    cell?.txtTo.tag = 4
                    cell?.txtFrom.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .touchUpInside)
                    cell?.txtTo.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .touchUpInside)
                    cell?.txtFrom.text = strTimeFrom
                    cell?.txtTo.text = strTimeTo
                    
                    if isSelectTxtField == false{
                        cell?.tblTimeSlot.isHidden = true
                    }else{
                        cell?.tblTimeSlot.isHidden = false
                    }
                    
                    if dictCart.count>0
                    {
                        let WalletPrice = dictCart.valueForNullableKey(key: kWalletAmount)
                        let intWalletPrice = Double(WalletPrice)!
                        cell?.lblMyWallet.text = "AED \(dictCart.valueForNullableKey(key: kWalletAmount))"
                        
                        if self.strTotalAmount != ""
                        {
                            var intTotalPrice = Double(strTotalAmount)
                            
                            if strCouponcode != ""
                            {
                                if isSelectedWallet == true
                                {
                                    let strAmount = self.dictCart.valueForNullableKey(key: KTotal)
                                    intTotalPrice = Double(strAmount)!
                                    
                                    strTotalAmount = "\(intTotalPrice! - self.IntDiscountPrice)"
                                    cell?.txtPromoCode.text = strCouponcode
                                    cell?.btnPromoCode.setTitle("Remove", for: .normal)
                                    cell?.LblOrderPrice.text = "AED \(self.dictCart.valueForNullableKey(key: KTotal))"
                                    cell?.lblDiscountedPrice.text = "AED \(self.IntDiscountPrice)"
                                    
                                }
                                else
                                {
                                    strTotalAmount = "\(intTotalPrice! - self.IntDiscountPrice)"
                                    cell?.txtPromoCode.text = strCouponcode
                                    cell?.btnPromoCode.setTitle("Remove", for: .normal)
                                    cell?.LblOrderPrice.text = "AED \(self.dictCart.valueForNullableKey(key: KTotal))"
                                    cell?.lblDiscountedPrice.text = "AED \(self.IntDiscountPrice)"
                                }
                                // if IntMinimumPriceForPromo <= intTotalPrice!
                                //    {
                                strTotalAmount = "\(intTotalPrice! - self.IntDiscountPrice)"
                                cell?.txtPromoCode.text = strCouponcode
                                cell?.btnPromoCode.setTitle("Remove", for: .normal)
                                cell?.LblOrderPrice.text = "AED \(self.dictCart.valueForNullableKey(key: KTotal))"
                                cell?.lblDiscountedPrice.text = "AED \(self.IntDiscountPrice)"
                                // }
                                //  else
                                //  {
                                //       strTotalAmount = "\(intTotalPrice!)"
                                //       cell?.txtPromoCode.text = ""
                                //       cell?.btnPromoCode.setTitle("Apply Code", for: .normal)
                                //       cell?.LblOrderPrice.text = "AED \(strTotalAmount)"
                                //       cell?.lblDiscountedPrice.text = "AED \(0)"
                                //        IntDiscountPrice = 0
                                //        strCouponcode = ""
                                //    }
                            }
                            else
                            {
                                let intTotalPrice = Double(strTotalAmount)
                                strTotalAmount = "\(intTotalPrice! - self.IntDiscountPrice)"
                                cell?.txtPromoCode.text = ""
                                cell?.btnPromoCode.setTitle("Apply Code", for: .normal)
                                cell?.LblOrderPrice.text = self.dictCart.valueForNullableKey(key: KTotal)
                                cell?.lblDiscountedPrice.text = "AED \(0)"
                                IntDiscountPrice = 0
                                strCouponcode = ""
                            }
                        }
                        if isSelectedWallet == true
                        {
                            let intTotalPrice = Double(strTotalAmount)
                            // self.isSelectedWallet = false
                            if intTotalPrice! > intWalletPrice
                            {
                                cell?.lblGrandTotal.text = "AED \(intTotalPrice!-intWalletPrice)"
                                
                                cell?.lblUsedWalletAmount.text = "AED \(dictCart.valueForNullableKey(key: kWalletAmount))"
                                btnPay.setTitle("Pay AED \(intTotalPrice!-intWalletPrice)", for: .normal)//"$\(OrderModel.TotalPriceCalculate-intWalletPrice)"
                                strFinalPricePay = "\(intTotalPrice!-intWalletPrice)"
                                strUsedWalletPrice = "\(intWalletPrice)"
                            }
                            else
                            {
                                cell?.lblUsedWalletAmount.text = "AED \(strTotalAmount)"
                                cell?.lblGrandTotal.text = "AED 0.00"
                                btnPay.setTitle("Pay AED 0.00", for: .normal)
                                strFinalPricePay = "0"
                                strUsedWalletPrice = "\(strTotalAmount)"
                                strPayForWallet = true
                            }
                        }
                        else
                        {
                            if strCouponcode != ""
                            {
                                let strAmount = self.dictCart.valueForNullableKey(key: KTotal)
                                var intTotalPrice = Double(strAmount)!
                                
                                cell?.lblUsedWalletAmount.text = "AED 0"
                                cell?.lblGrandTotal.text = "AED \(intTotalPrice - self.IntDiscountPrice)"
                                btnPay.setTitle("Pay AED \(intTotalPrice - self.IntDiscountPrice)", for: .normal)
                                strFinalPricePay = "\(intTotalPrice - self.IntDiscountPrice)"
                                strUsedWalletPrice = ""
                            }
                            else
                            {
                                let strAmount = self.dictCart.valueForNullableKey(key: KTotal)
                                var intTotalPrice = Double(strAmount)!
                                
                                cell?.lblUsedWalletAmount.text = "AED 0"
                                cell?.lblGrandTotal.text = "AED \(intTotalPrice)"
                                btnPay.setTitle("Pay AED \(intTotalPrice)", for: .normal)
                                strFinalPricePay = "\(intTotalPrice )"
                                strUsedWalletPrice = ""
                            }
                            
                        }
                    }
                    
                    cell?.btnWallet.addTarget(self, action: #selector(btnWallet(_:)), for: .touchUpInside)
                    cell?.btnPromoCode.addTarget(self, action: #selector(btnApplyCode(_:)), for: .touchUpInside)
                    //cell?.btnCardChange.addTarget(self, action: #selector(btnApplyCode(_:)), for: .touchUpInside)
                    
                    return cell!
                }
            }
            else if tableView.tag == 102{
                let indentifier:String = "TimeTblCell"
                var cell : TimeTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? TimeTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("TimeTblCell", owner: nil, options: nil)! as [Any]
                    cell = nib[0] as? TimeTblCell
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear)
                }
                cell?.lblTime.text = arrTime[indexPath.row]
                return cell!
            }
            else
            {
                let indentifier:String = "OrderFromTblCell"
                var cell : OrderFromTblCell? = tableView.dequeueReusableCell(withIdentifier: indentifier) as? OrderFromTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("OrderFromTblCell", owner: nil, options: nil)! as [Any]
                    cell = nib[0] as? OrderFromTblCell
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear)
                }
                if arrCartItem.count>0
                {
                    let arrCartMenu = ((arrCartItem[customTblClass.rowIndex] as! NSDictionary).value(forKey: kPlanMenus) as! NSArray)
                    let dictCart = arrCartMenu[indexPath.row] as! NSDictionary
                    
                    
                    if dictCart.object(forKey: "is_replace") as? Bool ?? false == true
                    {
                        cell?.btnDelete.setTitle("Discard Replace", for: .normal)
                    }
                    //                    else
                    //                    {
                    //
                    //                    }
                    strMenuID = dictCart.valueForNullableKey(key: kKitchenMenuId)
                    strMenuPrice = dictCart.valueForNullableKey(key: kPrice)
                    // strTotalAmount = dictCart.valueForNullableKey(key: KTotal)
                    
                    cell?.lblMenuName.text = dictCart.valueForNullableKey(key: ktitle)
                    cell?.lblMenuPrice.text = "AED \(dictCart.valueForNullableKey(key: kPrice))"
                    cell?.lblTotalPrice.text = "AED \(dictCart.valueForNullableKey(key: kSubtotal))"
                    cell?.lblQuantity.text = dictCart.valueForNullableKey(key: kQuantity)
                    cell?.imgMenu.sd_addActivityIndicator()
                    let url = URL.init(string: dictCart.valueForNullableKey(key: KImage))
                    cell?.imgMenu.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        cell?.imgMenu.sd_removeActivityIndicator()
                    })
                }
                
                
                
                cell?.btnDelete.tagSectionIndex = indexPath.section
                cell?.btnDelete.tagRowIndex = indexPath.row
                cell?.btnPlus.tag = indexPath.row
                cell?.btnMinus.tag = indexPath.row
                cell?.btnPlus.addTarget(self, action: #selector(btnAdd(_:)), for: .touchUpInside)
                cell?.btnMinus.addTarget(self, action: #selector(btnMinus(_:)), for: .touchUpInside)
                cell?.btnDelete.addTarget(self, action: #selector(btnReplace(_:)), for: .touchUpInside)
                return cell!
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            if tableView.tag == 101
            {
                if indexPath.section == 1
                {
                    if ((arrCartItem.object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kPlanMenus) as! NSArray).count > 0
                    {
                        if ((arrCartItem.object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kPlanMenus) as! NSArray).count == 1
                        {
                            return (CGFloat(((arrCartItem.object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kPlanMenus) as! NSArray).count * 190))
                        }
                        else
                        {
                            return (CGFloat(((arrCartItem.object(at: customTblClass.rowIndex) as! NSDictionary).object(forKey: kPlanMenus) as! NSArray).count * 160))
                        }
                    }
                    else
                    {
                        return UITableView.automaticDimension
                    }
                }
                else
                {
                    return UITableView.automaticDimension
                }
            }
            else
            {
                return UITableView.automaticDimension
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
                tblView.reloadData()
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        @objc func MethodMyCartAPI()
        {
            getallApiResultwithPostTokenMethod(Details:NSMutableDictionary(), strMethodname: kMethodMyCarts) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            self.dictCart = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                            
                            self.strTotalAmount = self.dictCart.valueForNullableKey(key: KTotal)
                            self.btnPay.setTitle("PLACE YOUR ORDER AED \(self.strTotalAmount)", for: .normal)
                            self.arrCartItem = (self.dictCart.value(forKey: kCart) as! NSArray).mutableCopy() as! NSMutableArray
                            self.tblView.reloadData()
                        }
                        else
                        {
                            self.dictCart = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                            //                            if self.dictCart.count > 0
                            //                            {
                            //                                self.lblNoDataFound.isHidden = true
                            //                                self.tblView.isHidden = false
                            //                                self.btnPay.isHidden = false
                            //                            }
                            //                            else
                            //                            {
                            self.lblNoDataFound.isHidden = false
                            self.tblView.isHidden = true
                            self.btnPay.isHidden = true
                            //    }
                            self.tblView.reloadData()
                            // self.onShowAlertController(title: kError, message: responseData?.object(forKey: kMessage) as? String)
                            
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
        @objc func MethodAddToCartAPI(dictCartDetail: NSDictionary)
        {
            getallApiResultwithPostTokenMethod(Details:dictCartDetail, strMethodname: kMethodAddToCart) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            if self.appDelegate.isInternetAvailable() == true{
                                self.windowShowActivity(text: "")
                                self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
                            }else
                            {
                                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                            }
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
        
        //MARK: - Replace Cart Value
        
        @objc func methodReplaceItem(dataDict : NSDictionary)
        {
            
            
            getallApiResultwithPostTokenMethod(Details:dataDict, strMethodname: kReplaceItem) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            
                            //                                       if self.appDelegate.isInternetAvailable() == true{
                            //                                           self.windowShowActivity(text: "")
                                self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
                            //                                       }else
                            //                                       {
                            //                                           self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                            //                                       }
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
                            if self.appDelegate.isInternetAvailable() == true{
                                self.windowShowActivity(text: "")
                                self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
                            }else
                            {
                                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
                            }
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
        
        
        //MARK:- UItextFeild Validation Method...........
        func checkValidation() -> Bool
        {
            var cart_exist : Bool = false
            for i in 0..<self.arrCartItem.count
            {
                let cartDetail = self.arrCartItem.object(at: i) as! NSDictionary
                
                if cartDetail.object(forKey: "cart_exist") as? Int ?? 0 == 1
                {
                    cart_exist = true
                    
                }
            }
            if cart_exist == true{
                onShowAlertController(title: kError, message: CartNoComplete)
                return false
            }
            
            if self.strTimeFrom == ""
            {
                onShowAlertController(title: kError, message: ValidBreakFastFromTime)
                return false
            }
            else if strTimeTo == ""
            {
                onShowAlertController(title: kError, message: ValidBreakFastToTime)
                return false
            }
            else if StrAddressID == ""
            {
                onShowAlertController(title: kError, message: KDeliveryAddress)
                return false
            }
            return true
        }
        
        func AddOrderParam() -> NSMutableDictionary
        {
            let DataPassDict = NSMutableDictionary()
            // DataPassDict.setValue(self.strKitchenID, forKey: kKitchenID)
            //DataPassDict.setValue(strKitchenMenuID, forKey: kKitchenMenuId)
            DataPassDict.setValue(StrAddressID, forKey: kAddressId) //dictKitchen.valueForNullableKey(key: kUserAddressID)
            DataPassDict.setValue(strCouponcode, forKey: kPromoCode)//DataPassDict.setValue(IntDiscountPrice, forKey: kPromoCode)
            if isSelectedWallet == true{
                DataPassDict.setValue("", forKey: kPaymentToken)
                DataPassDict.setValue(strUsedWalletPrice, forKey: kWalletAmount)
            }else{
                DataPassDict.setValue("", forKey: kWalletAmount)
            }
            DataPassDict.setValue(strFinalPricePay, forKey: kAmount) //OrderModel.TotalPriceCalculate
            DataPassDict.setValue("Free", forKey: kDeliveryFee)
            DataPassDict.setValue(strDeliveryNote, forKey: kSpcialNote)
            DataPassDict.setValue(strTimeFrom, forKey: kDeliveryTimeFrom)
            DataPassDict.setValue(strTimeTo, forKey: kDeliveryTimeTo)
            if strSelectFormattedString == ""{
                strSelectFormattedString = self.appDelegate.formattedDate.convertDatetring_TopreferredFormat(currentFormat: "EEEE-yyyy-mm-dd", toFormat: "YYYY-MM-dd")
                DataPassDict.setValue(strSelectFormattedString, forKey: kDates)
            }else{
                DataPassDict.setValue(strSelectFormattedString, forKey: kDates)
            }
            DataPassDict.setValue(false, forKey: kisSave)
            DataPassDict.setValue("", forKey: kCardId)
            DataPassDict.setValue(appDelegate.StrDeliverytype, forKey: kDeliveryStatus)
            //            DataPassDict.setValue(strQuantity, forKey: kQty)
            //            DataPassDict.setValue(strTotalPrice, forKey: kMenuAmount)
            
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
                            //let strOrderId = data.valueForNullableKey(key: kId)
                            //kOrderId
                            let strOrderId = data.valueForNullableKey(key: kOrderId)
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
        
        //MARK: - ApplyPromoCode API Intigartion...................
        func ApplyCodeParam() -> NSMutableDictionary
        {
            let dict = NSMutableDictionary()
            
            dict.setObject(strCouponcode, forKey: kPromoCode as NSCopying)
            dict.setObject(strTotalAmount, forKey: kAmount as NSCopying)
            return dict
        }
        
        @objc func ApplyCodeApi()
        {
            getallApiResultwithPostTokenMethod(Details: ApplyCodeParam(), strMethodname: kMethodApplyPromocode) { (responseData, error) in
                
                DispatchQueue.main.async {
                    //self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                            //self.strTotalAmount = ""
                            self.tblView.reloadData()
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
    
    
