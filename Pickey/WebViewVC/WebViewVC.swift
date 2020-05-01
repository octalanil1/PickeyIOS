//
//  WebViewVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 21/02/20.
//  Copyright © 2020 Sunil Pradhan. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!           
    
    var isNavigation = ""
    var StrUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Indicator.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: isNavigation , leftbuttonImageName: "back", RightbuttonName: "")
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodBackBtnAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        if self.appDelegate.isInternetAvailable() == true
        {
            self.showActivity(text: "")
            self.performSelector(inBackground: #selector(self.CMSAPI), with: nil)
        }
        else
        {
            self.onShowAlertController(title: "No Internet Connection" , message: kInternetError)
        }
    }
    
    @objc func methodBackBtnAction(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Web View Methods
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        Indicator.stopAnimating()
        Indicator.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        Indicator.stopAnimating()
        Indicator.isHidden = true
    }
    
    func CMSParam() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict.setObject(StrUrl, forKey: kSlug as NSCopying)
        return dict
    }
    
    // MARK:- CMS API Integration
    @objc func CMSAPI()
    {
        
        getallApiResultwithPostTokenMethod(Details: CMSParam(), strMethodname: kMethodCmsPages) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    self.hideActivity()
                    
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as!  Int == kStatusResponseTrue)
                    {
                        let data = responseData?.object(forKey: kResponseDataDict) as! NSDictionary
                        let strDescription = data.valueForNullableKey(key: "short_description")
                        self.webView.loadHTMLString(strDescription, baseURL: nil)
                        self.Indicator.stopAnimating()
                        self.Indicator.isHidden = true
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
