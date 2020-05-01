//
//  PaymentVC.swift
//  Pickey
//
//  Created by octal on 18/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var isSelectedIndex = 0
    var isIndexSelected = false
    var isCashOnDelivery = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        registercell()
    }
    func registercell()
    {
        tblView.register(UINib(nibName: "SavedCardTblCell", bundle: nil), forCellReuseIdentifier: "SavedCardTblCell")
        tblView.register(UINib(nibName: "CashOnDeliveryTblCell", bundle: nil), forCellReuseIdentifier: "CashOnDeliveryTblCell")
        tblView.register(UINib(nibName: "AddNewCardTblCell", bundle: nil), forCellReuseIdentifier: "AddNewCardTblCell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNewCard(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCardVC") as! AddNewCardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- tableView Delegate and DataSource......................
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 2
        }
        else if section == 1
        {
            return 1
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardTblCell") as! SavedCardTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.btnCross.isHidden = false
            if self.isSelectedIndex == indexPath.row && self.isIndexSelected == true{
                cell.btnRight.isHidden = false
            }else{
                cell.btnRight.isHidden = true
            }
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CashOnDeliveryTblCell") as! CashOnDeliveryTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.btnRight.isHidden = true
            if isCashOnDelivery == true{
                cell.btnRight.isHidden = false
            }else{
                cell.btnRight.isHidden = true
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCardTblCell") as! AddNewCardTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            if self.isSelectedIndex == indexPath.row && self.isIndexSelected == true{
                self.isIndexSelected = false
                self.isCashOnDelivery = false
            }else{
                self.isIndexSelected = true
                self.isCashOnDelivery = false
            }
            self.isSelectedIndex = indexPath.row
            self.tblView.reloadData()
        }
        else if indexPath.section == 1
        {
            if isCashOnDelivery == true
            {
                self.isCashOnDelivery = false
                self.isIndexSelected = true
            }
            else
            {
                self.isCashOnDelivery = true
                self.isIndexSelected = false
            }
            self.isSelectedIndex = indexPath.row
            self.tblView.reloadData()
        }
        else
        {
            let NavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCardVC") as! AddNewCardVC
            self.navigationController?.pushViewController(NavCtrl, animated: true)
        }
    }
}

