//
//  RatingPopUPVC.swift
//  Pickey
//
//  Created by octal on 26/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class RatingPopUPVC: UIViewController, FloatRatingViewDelegate {

    @IBOutlet weak var txtrate:UITextView!
    @IBOutlet weak var btn_close:UIButton!
    @IBOutlet weak var viewRating: FloatRatingView!
    var dictReview = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtrate.layer.cornerRadius = 5
        txtrate.clipsToBounds = true
        txtrate.layer.borderColor = UIColor.init(red: 242/255, green: 243/255, blue: 245/255, alpha: 1).cgColor
        txtrate.layer.borderWidth = 1
        txtrate.contentInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 5);
        viewRating?.delegate = self
        viewRating?.backgroundColor = UIColor.clear
        viewRating?.contentMode = UIView.ContentMode.scaleAspectFit
        viewRating?.type = .halfRatings
        viewRating?.editable = true
        addInputAccessoryForTextView(textViews: [txtrate], dismissable: true, previousNextable: true)
        print(dictReview)
    }
    
    @IBAction func Close()
     {
         self.removeFromParent()
         self.view.removeFromSuperview()
         self.view.endEditing(true)
     }

    @IBAction func Submit()
    {
        self.view.endEditing(true)
        if self.appDelegate.isInternetAvailable() == true
        {
            self.windowShowActivity(text: "")
            self.performSelector(inBackground: #selector(self.MethodAddReviewApi), with: nil)
        
        }else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    //MARK: - AddReview Api Integration................
    func AddReviewParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(dictReview.value(forKey: kKitchenID)!, forKey: kKitchenID as NSCopying)
        dict.setObject(dictReview.value(forKey: kOrderId)!, forKey: kOrderId as NSCopying)
        dict.setObject(viewRating.rating, forKey: kRating as NSCopying)
        dict.setObject(txtrate.text!, forKey: KitchenDescrition as NSCopying)
        
        return dict
    }
    @objc func MethodAddReviewApi()
    {
        getallApiResultwithPostTokenMethod(Details:AddReviewParam(), strMethodname: kMethodAddReview) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.onShowAlertController(title: kMessage, message: responseData?.object(forKey: kMessage) as? String)
                        
                        self.removeFromParent()
                        self.view.removeFromSuperview()
                        NotificationCenter.default.post(name: Notification.Name("RateAndReviewNoti"), object: nil)
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
