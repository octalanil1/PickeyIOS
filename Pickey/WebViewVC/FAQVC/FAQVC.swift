//
//  FAQVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 14/03/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class FAQVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var arrFAQ = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.MethodFAQAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
        }
    }
    
    //MARK:- tableView Delegate and DataSource......................
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrFAQ.count>0
        {
            return arrFAQ.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "FAQTblCell", for: indexPath as IndexPath) as! FAQTblCell
        let data = arrFAQ[indexPath.row] as! NSDictionary
        Cell.lblQuetion.text = data.valueForNullableKey(key: kAnswer)
        Cell.lblAnswer.text = data.valueForNullableKey(key: kQuestion)
        Cell.selectionStyle = .none
        Cell.backgroundColor = .clear
        return Cell
    }
    
    // MARK:- Method FAQ API Integration................
    @objc func MethodFAQAPI()
    {
        getallApiResultwithPostTokenMethod(Details: NSDictionary(), strMethodname: kMethodFAQ) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as!  Int == kStatusResponseTrue)
                    {
                        self.arrFAQ = responseData?.object(forKey: kResponseDataDict) as! NSArray
                        self.tblView.reloadData()
                    }
                    else if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == ktokenExpire)
                    {
                        let alert = UIAlertController(title: "", message:responseData?.object(forKey: kMessage) as? String , preferredStyle: .alert)
                        
                        let actionAllow = UIAlertAction(title: "OK", style: .default) { alert in
                            
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
