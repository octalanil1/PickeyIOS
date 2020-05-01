//
//  KitchenDetailVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 01/04/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class KitchenDetailVC: UIViewController, FloatRatingViewDelegate {

    var strKitchenName = ""
    var dictKitchenDetails = NSDictionary()
    
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var lblKItchenName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblMobileNo:UILabel!
    @IBOutlet weak var lblReview:UILabel!
    @IBOutlet weak var lblExp:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var lblNote:UILabel!
    @IBOutlet weak var lblBio:UILabel!
    @IBOutlet weak var viewRating:FloatRatingView!
    @IBOutlet weak var imgKitchen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: dictKitchenDetails.valueForNullableKey(key: Kitchenname), leftbuttonImageName: "", RightbuttonName: "")
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
         viewRating?.delegate = self
         viewRating?.backgroundColor = UIColor.clear
         viewRating?.contentMode = UIView.ContentMode.scaleAspectFit
         viewRating?.type = .halfRatings
         viewRating?.emptyImage = UIImage.init(named: "rating_gray")
         viewRating?.fullImage = UIImage.init(named: "rating")
         viewRating?.editable = false
         
         lblKItchenName.text = dictKitchenDetails.valueForNullableKey(key: Kitchenname)
         lblAddress.text = dictKitchenDetails.valueForNullableKey(key: KitchenAddress)
         lblMobileNo.text = dictKitchenDetails.valueForNullableKey(key: kMobileNumber)
         lbldescription.text = dictKitchenDetails.valueForNullableKey(key: KitchenDescription)
         viewRating = dictKitchenDetails.value(forKey: kRating) as? FloatRatingView
         lblReview.text = dictKitchenDetails.valueForNullableKey(key: kReview)
         

         imgKitchen.sd_addActivityIndicator()
         let url = URL.init(string: dictKitchenDetails.valueForNullableKey(key: KitchenImage))
         imgKitchen.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ImgDefault"), options: .refreshCached, completed: { (img, error, cacheType, url) in
             self.imgKitchen.sd_removeActivityIndicator()
         })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
        
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func methodAddCart(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
