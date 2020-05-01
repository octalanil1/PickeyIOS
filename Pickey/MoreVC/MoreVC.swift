//
//  MoreVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 19/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrTitle = ["Faq's", "Contact Us", "Blog", "Support", "Terms & Condition", "About Us"]
    var arrImages = [UIImage.init(named: "faq"), UIImage.init(named: "contact_us"), UIImage.init(named: "blog"), UIImage.init(named: "support"), UIImage.init(named: "t&c"), UIImage.init(named: "t&c")]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "More", leftbuttonImageName: "", RightbuttonName: "")
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTblCell") as! MoreTblCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = (UIColor.clear)
        
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.imgTitle.image = arrImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQVC") as! FAQVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.StrUrl = "contact-us"
            vc.isNavigation = "Contact Us"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2
        {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
           vc.StrUrl = "blog"
           vc.isNavigation = "Blog"
           self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.StrUrl = "contact-us"
            vc.isNavigation = "Support"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 4
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.StrUrl = "terms-and-conditions"
            vc.isNavigation = "Terms & Conditions"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.StrUrl = "about_us"
            vc.isNavigation = "About Us"
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}
