//
//  SelectTypeVC.swift
//  Pickey
//
//  Created by octal on 29/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class SelectTypeVC: UIViewController {
    
    @IBOutlet weak var Collectionv:UICollectionView!
    @IBOutlet weak var mview:UIView!
    @IBOutlet weak var txt_deliverynote:UITextView!
    @IBOutlet weak var btnBreakFastChk:UIButton!
    @IBOutlet weak var btnLunchChk:UIButton!
    @IBOutlet weak var btnDinnerChk:UIButton!
    @IBOutlet weak var btnPay:UIButton!
    
    var dictKitchenOrder = NSMutableDictionary()
    
    var isSelectedIndex = 0
    var isIndexSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBreakFastChk.tag = 15
        btnLunchChk.tag = 16
        btnDinnerChk.tag = 17
        
        txt_deliverynote.layer.cornerRadius = 3
        txt_deliverynote.layer.borderColor = UIColor.lightGray.cgColor
        txt_deliverynote.layer.borderWidth = 0.5
        addInputAccessoryForTextView(textViews: [txt_deliverynote], dismissable: true, previousNextable: true)
        
        btnPay.setTitle("AED \(OrderModel.TotalPriceCalculate)", for: .normal)
        registercell()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList(_:)), name: NSNotification.Name(rawValue: "SendData"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    @objc func refreshList(_ notification: Notification)
    {
        print(notification)
        
        dictKitchenOrder = notification.object as! NSMutableDictionary
        
        print(dictKitchenOrder)
    }
    @IBAction func btnClose(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 1, initialSpringVelocity: 1.0,
                       options: .allowAnimatedContent, animations: {
                        self.view.center = CGPoint(x: self.view.center.x,y: self.view.center.y + self.view.frame.size.height)
        }) { (isFinished) in
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func Orderscreen(_ sender:UIButton)
    {
        AddOrderApi()
    }
    
    func registercell(){
        let cellSize = CGSize(width:139 , height:40)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        Collectionv.setCollectionViewLayout(layout, animated: true)
        Collectionv.register(UINib(nibName: "DeliveryTimeCell", bundle: nil), forCellWithReuseIdentifier: "DeliveryTimeCell")
        
    }
    @IBAction func Selectchk(_ sender:UIButton)
    {
        if sender.tag == 15
        {
            sender.isSelected = !sender.isSelected
        }
        if sender.tag == 16
        {
            sender.isSelected = !sender.isSelected
        }
        if sender.tag == 17
        {
            sender.isSelected = !sender.isSelected
        }
    }
    
    //MARK:- UItextFeild Validation Method...........
    func checkValidation() -> Bool
    {
        if self.txt_deliverynote.text == ""
        {
            onShowAlertController(title: kError, message: emptyDeliveryNote)
            return false
        }
        return true
    }
    
    //MARK: AddOrder API Integration.................
    func AddOrderApi()
    {
        self.view.endEditing(true)
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.KitchenMethodApi), with: nil)
            
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    func AddOrderParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kKitchenID), forKey: kKitchenID as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kAddressId), forKey: kAddressId as NSCopying)
        dict.setObject("", forKey: kPlanid as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kPromoCode), forKey: kPromoCode as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kAmount), forKey: kAmount as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kAmount), forKey: kAmount as NSCopying)
        dict.setObject(txt_deliverynote.text!, forKey: kSpcialNote as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kDates), forKey: kDates as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kMealType), forKey: kMealType as NSCopying)
        dict.setObject(dictKitchenOrder.valueForNullableKey(key: kOrderQuantity), forKey: kOrderQuantity as NSCopying)
        
        return dict
    }
    @objc func KitchenMethodApi()
    {
        getallApiResultwithPostTokenMethod(Details:AddOrderParam(), strMethodname: kMethodAddOrder) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaceVC") as! OrderPlaceVC
                        self.navigationController?.pushViewController(NavCtrl, animated: false)
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
extension SelectTypeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryTimeCell", for: indexPath) as! DeliveryTimeCell
        if self.isSelectedIndex == indexPath.row && self.isIndexSelected == true
        {
            cell.mview.layer.borderColor = UIColor.init(red: 233/255, green: 105/255, blue: 48/255, alpha: 1).cgColor
            cell.mview.layer.borderWidth = 1
        }
        else
        {
            cell.mview.backgroundColor = UIColor.white
            cell.mview.layer.borderWidth = 1
            cell.mview.layer.borderColor = UIColor.lightGray.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isSelectedIndex == indexPath.row && self.isIndexSelected == true{
            self.isIndexSelected = false
        }else{
            self.isIndexSelected = true
        }
        self.isSelectedIndex = indexPath.row
        self.Collectionv.reloadData()
    }
}
