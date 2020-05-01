//
//  InviteFriendVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class InviteFriendVC: UIViewController {

    //MARK:- Outlets and Variables/Objects..............
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblReferAndEarn: UILabel!
    @IBOutlet weak var ViewCode: UIView!
    
    //MARK:- System Defined Methods............
    override func viewDidLoad()
    {
        super.viewDidLoad()

       // ViewCode.addDashedBorder(UIColor.init(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1.0), withWidth: 2, cornerRadius: 5, dashPattern: [6,3])
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Invite Friends", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
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
    
     //MARK:- UIButton Actions..............
    @IBAction func btnBack(_ sender: UIButton)
    {
    }

    @IBAction func btnShare(_ sender: UIButton)
    {
        let URLstring =  String(format:"https://picky12.page.link/jdF1")
        let urlToShare = URL(string:URLstring)
        let title = "title to be shared"
        let activityViewController = UIActivityViewController(
            activityItems: [urlToShare!,title],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        //so that ipads won't crash
        present(activityViewController,animated: true,completion: nil)
//
//        let someText:String = "Share Link"
//        let objectsToShare:URL = URL(string: "http://www.google.com")!
//        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
//        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail,UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.addToReadingList]
//
//        self.present(activityViewController, animated: true, completion: nil)
    }
}
