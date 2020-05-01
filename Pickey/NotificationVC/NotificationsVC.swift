//
//  NotificationsVC.swift
//  Picky
//
//  Created by octal on 20/11/19.
//  Copyright © 2019 octal. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dictNotification = NSDictionary()
    var arrNoti = NSMutableArray()
    var currentPage  = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Notifications", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.getNotification), with: nil)
        }
        else
        {
            self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
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
    /*
    //MARK:- Scroll View Method.........
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if self.arrNoti.count > 0 //&& self.currentPage < self.LastPage
        {
            let sec = (scrollView as! UITableView).numberOfSections - 1
            let roww = (scrollView as! UITableView).numberOfRows(inSection: sec) - 1
            let lastVisibleIndexPath = IndexPath.init(row: roww, section: sec)
            if lastVisibleIndexPath != nil
            {
                let dataCount = self.arrNoti.count - 1
                let dif = abs(dataCount - lastVisibleIndexPath.item)
                
                if dif == 0
                {
                    self.currentPage += 1
                    self.performSelector(inBackground: #selector(self.getNotification), with: nil)
                }
            }
        }
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrNoti.count>0
        {
           return self.arrNoti.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath as IndexPath) as! NotificationsCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if arrNoti.count>0
        {
            let dict = arrNoti[indexPath.row] as! NSDictionary
            cell.lblNotification.text = dict.valueForNullableKey(key: ktitle)
            let SelectDate = dict.valueForNullableKey(key: KitchenCreatedDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let showDate = dateFormatter.date(from:SelectDate)
            let resultString = dateFormatter.string(from: showDate!)
            let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "EEEE, MMM d, yyyy h:mm a")
            cell.lblTime.text = resultString1
        }
            
        return cell
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 81
    }
    
    func getNotificationParameter() -> NSMutableDictionary
    {
        let dictNoti = NSMutableDictionary()
        dictNoti.setObject(currentPage,forKey: kPage as NSCopying)
        return dictNoti
    }
    
    // MARK:- getNotification API Integration
    @objc func getNotification()
    {
        
        getallApiResultwithPostTokenMethod(Details: getNotificationParameter(), strMethodname: kMethodNotificationList) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    
                    if (self.currentPage == 1)
                    {
                        self.arrNoti.removeAllObjects()
                    }
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.arrNoti = (responseData?.object(forKey: kResponseDataDict) as! NSArray).mutableCopy() as! NSMutableArray
//                        if self.arrNoti.count > 0 && self.currentPage == 1
//                        {
//                            self.arrNoti.removeAllObjects()
//                        }
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
}
