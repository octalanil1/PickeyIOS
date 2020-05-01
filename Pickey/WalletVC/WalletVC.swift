//
//  WalletVC.swift
//  Pickey
//
//  Created by octal on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class WalletVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tbl_data:UITableView!
    
    var dictWallet = NSDictionary()
    var arrWalletHistory = NSMutableArray()
    
    var currentPage  = 0
    var LastPage   = 1
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registercell()
        
        refreshControl.addTarget(self, action: #selector(PoolToRefresh), for:UIControl.Event.valueChanged)
        tbl_data.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "Wallet", leftbuttonImageName: "", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu.png")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cart_selected")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodAddCart(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.getWalletList), with: nil)
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
    
    //PoolRefresh
    @objc func PoolToRefresh()
    {
        //getRecentChat
        self.performSelector(inBackground: #selector(self.getWalletList), with: nil)
        refreshControl.isHidden = false
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        })
    }
    
    func registercell()
    {
        tbl_data.register(UINib(nibName: "HeaderWalletCell", bundle: nil), forCellReuseIdentifier: "HeaderWalletCell")
        tbl_data.register(UINib(nibName: "PayWalletCell", bundle: nil), forCellReuseIdentifier: "PayWalletCell")
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0//Top header
        {
            return 1
        }
        else{
            if self.arrWalletHistory.count>0
            {
               return self.arrWalletHistory.count
            }else
            {
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderWalletCell") as! HeaderWalletCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if dictWallet.count>0
            {
                cell.lblPrice.text = "AED \(dictWallet.valueForNullableKey(key: kWalletAmount))"
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayWalletCell") as! PayWalletCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if self.arrWalletHistory.count>0
            {
                let data = self.arrWalletHistory[indexPath.row] as! NSDictionary
                cell.lblWalletId.text = "#\(data.valueForNullableKey(key: kId))"
                
                if data.valueForNullableKey(key: kRefaundAmount) == "0.00"
                {
                    cell.lblPrice.text = "AED \(data.valueForNullableKey(key: kUsedAmount))"
                    cell.imgCreditDebit.image = UIImage.init(named: "debit")
                }
                else
                {
                    cell.lblPrice.text = "AED \(data.valueForNullableKey(key: kRefaundAmount))"
                    cell.imgCreditDebit.image = UIImage.init(named: "credit")
                }
                
                let SelectDate = data.valueForNullableKey(key: KitchenCreatedDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let showDate = dateFormatter.date(from:SelectDate)
                let resultString = dateFormatter.string(from: showDate!)
                let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "EEEE, MMM d, yyyy h:mm a")
                cell.lblDate.text = resultString1
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 190
        }
        else{
            return 82
        }
    }
    
    @IBAction func openTopup(_ sender:UIButton)
    {
        let menuVC  = self.storyboard!.instantiateViewController(withIdentifier: "TopUPVC") as! TopUPVC
        
        self.addChild(menuVC)
        self.view.addSubview(menuVC.view)
        menuVC.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height-250, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
    }
 /*
    //MARK:- Scroll View Method.........
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if self.arrWalletHistory.count > 0 //&& self.currentPage < self.LastPage
        {
            let sec = (scrollView as! UITableView).numberOfSections - 1
            let roww = (scrollView as! UITableView).numberOfRows(inSection: sec) - 1
            let lastVisibleIndexPath = IndexPath.init(row: roww, section: sec)
            if lastVisibleIndexPath != nil
            {
                let dataCount = self.arrWalletHistory.count - 1
                let dif = abs(dataCount - lastVisibleIndexPath.item)
                
                if dif == 0
                {
                    self.currentPage += 1
                    self.performSelector(inBackground: #selector(self.getWalletList), with: nil)
                }
            }
        }
    }
 */
    
   func WalletListParameter() -> NSMutableDictionary
   {
       let dictWallet = NSMutableDictionary()
       dictWallet.setObject(currentPage,forKey: kPage as NSCopying)
       return dictWallet
   }
    
    // MARK:- getProfile API Integration
    @objc func getWalletList()
    {
        getallApiResultwithPostTokenMethod(Details: WalletListParameter(), strMethodname: kMethodWalletHistory) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
//                    if (self.currentPage == 1)
//                    {
//                        self.arrWalletHistory.removeAllObjects()
//                        self.LastPage = 1
//                    }
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        self.dictWallet = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        self.arrWalletHistory = (self.dictWallet.value(forKey: kMethodWalletHistory) as! NSArray).mutableCopy() as! NSMutableArray
                        
//                        if self.arrWalletHistory.count > 0 && self.currentPage == 1
//                        {
//                            self.arrWalletHistory.removeAllObjects()
//                        }

                       // self.LastPage = (responseData?.object(forKey: kResponseDataDict) as! NSDictionary).object(forKey: klastPage) as! Int

                        self.tbl_data.reloadData()
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
