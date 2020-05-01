//
//  RateAndReview.swift
//  Picky
//
//  Created by octal on 20/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit

class RateAndReview: UIViewController, UITableViewDataSource, UITableViewDelegate, FloatRatingViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var arrreviewdata = NSMutableArray()
    var strRating = ""
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 165
        tableView.rowHeight = UITableView.automaticDimension
        GetReviewList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Rate and Review", leftbuttonImageName: "", RightbuttonName: "")
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: NSNotification.Name(rawValue: "RateAndReviewNoti"), object: nil)
    }
    
    @objc func updateData(notification: NSNotification)
    {
        GetReviewList()
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
    
    @objc func RatingView(_ sender:UIButton)
    {
        let dictdata = self.arrreviewdata.object(at: sender.tag) as! NSDictionary
        let vc = storyboard?.instantiateViewController(withIdentifier: "RatingPopUPVC")as! RatingPopUPVC
        vc.dictReview = dictdata
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrreviewdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dictdata = self.arrreviewdata.object(at: indexPath.row) as! NSDictionary
        let isRating = dictdata.valueForNullableKey(key: kisRating)
        if isRating == "1"
        {
            let RateCell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath as IndexPath) as! RateCell
            RateCell.selectionStyle = .none
            RateCell.backgroundColor = .clear
            RateCell.lblFoodName.sizeToFit()
            RateCell.RatingView?.delegate = self
            RateCell.RatingView?.backgroundColor = UIColor.clear
            RateCell.RatingView?.contentMode = UIView.ContentMode.scaleAspectFit
            RateCell.RatingView?.type = .halfRatings
            RateCell.RatingView?.editable = false
            
            if dictdata.count>0
            {
                RateCell.lblFoodName.text = dictdata.valueForNullableKey(key: Kitchenname)
                RateCell.lblAddress.text = dictdata.valueForNullableKey(key: KitchenAddress)
                RateCell.lblCreatedDate.text = dictdata.valueForNullableKey(key: KitchenCreatedDate)
                RateCell.foodImgView.sd_addActivityIndicator()
                let url = URL.init(string: dictdata.value(forKey: KitchenImage) as! String)
                RateCell.foodImgView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                RateCell.foodImgView.sd_removeActivityIndicator()  //logo.jpg
                })
                let dictReview = dictdata.object(forKey: kKitchenReviewData) as! NSDictionary
                if dictReview.count>0
                {
                    let rating = dictReview.valueForNullableKey(key: KitchenRating)
                    RateCell.RatingView.rating = Double(rating)!
                    RateCell.lblDescription.text = dictReview.valueForNullableKey(key: KitchenDescrition)
                }
            }
            return RateCell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath as IndexPath) as! ReviewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if dictdata.count>0
            {
                cell.lblFoodName.text = dictdata.valueForNullableKey(key: Kitchenname)
                cell.lblAddress.text = dictdata.valueForNullableKey(key: KitchenAddress)
                let url = URL.init(string: dictdata.value(forKey: KitchenImage) as! String)
                cell.foodImgView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                cell.foodImgView.sd_removeActivityIndicator()  //logo.jpg
                })
            }
            cell.btnReview.tag = indexPath.row
            cell.btnReview.addTarget(self, action: #selector(RatingView(_:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    //Mark: ReviewList
    func GetReviewList()
    {
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.ReviewMethodAPI), with: nil)
        } else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    @objc func ReviewMethodAPI()
    {
        getallApiResultwithPostTokenMethod(Details:[:], strMethodname: kMethodMyReview) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.arrreviewdata = (responseData?.value(forKey: kResponseDataDict) as! NSArray).mutableCopy() as! NSMutableArray
                        self.tableView.reloadData()
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

