//
//  FilterVC.swift
//  Pickey
//
//  Created by Sunil Pradhan on 28/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var arrData = ["Sort by:", "Food Type:", "Kitchens:"]
    var arrSortBy = ["Rating high to low", "Rating low to high"]
    var arrFoodType = ["Indian Food", "Emirati Food", "Chinese Food"]
    var arrDietFree = ["Gluten Free", "Soy Free", "Dairy Free"]
    
    var isSelectedIndexSortBy = 0
    var isIndexSelectedSortBy = false
    
    var isSelectedIndexFoodType = 0
    var isIndexSelectedFoodType = false
    
    var isSelectedIndexKichen = 0
    var isIndexSelectedKichen = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.removeFromParent()
        self.view.removeFromSuperview()
        NotificationCenter.default.post(name: Notification.Name("sendFilter"), object: strRatingOrder)
    }
    
    //MARK: - Uicollection ViewDelegate and DataSource.........
 /*
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrKitchens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodTypeCollCell", for: indexPath) as! FoodTypeCollCell
        
         if self.isSelectedIndexFoodType == indexPath.row && self.isIndexSelectedFoodType == true
         {
            cell.btnFoodName.setTitleColor(UIColor.init(red: 231/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0), for: .normal)
            cell.btnFoodName.layer.borderColor = UIColor.init(red: 231/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
         }
         else
         {
            cell.btnFoodName.setTitleColor(UIColor.lightGray, for: .normal)
            cell.btnFoodName.layer.borderColor = UIColor.lightGray.cgColor
         }
        
        cell.btnFoodName.setTitle(arrKitchens[indexPath.row], for: .normal)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width/4, height: 25)
        // return CGSize(width: collectionView.frame.width/4 - 10, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if self.isSelectedIndexFoodType == indexPath.row && self.isIndexSelectedFoodType == true{
            self.isIndexSelectedFoodType = false
        }else{
            self.isIndexSelectedFoodType = true
        }
        self.isSelectedIndexFoodType = indexPath.row
        tblView.reloadData()
    }
  */
    
    //MARK: - tableView Delegate and DataSource.........
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2//arrData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       // return arrSortBy.count
        
        if section == 0
        {
            return arrSortBy.count
        }
//        else  if section == 1
//        {
//            return 1
//        }
        else
        {
            return arrDietFree.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortByTblCell") as! SortByTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if self.isSelectedIndexSortBy == indexPath.row && self.isIndexSelectedSortBy == true
            {
                cell.btnRight.isHidden = false
                strRatingOrder = arrSortBy[indexPath.row]
            }
            else
            {
               cell.btnRight.isHidden = true
            }
            cell.lblTitle.text = arrSortBy[indexPath.row]
            
            return cell
        }
//        else  if indexPath.section == 1
//        {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTypeTblCell") as! FoodTypeTblCell
//            cell.selectionStyle = .none
//            cell.CollView.delegate = self
//            cell.CollView.dataSource = self
//
//            let nib1 = UINib(nibName: "FoodTypeCollCell", bundle: nil)
//            cell.CollView.register(nib1, forCellWithReuseIdentifier: "FoodTypeCollCell")
//
//            return cell
//        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KitchensTblCell", for: indexPath) as! KitchensTblCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if self.isSelectedIndexKichen == indexPath.row && self.isIndexSelectedKichen == true
            {
                let strDiet = arrDietFree[indexPath.row]
                if strDiet == "Gluten Free"
                {
                    strGF = "1"
                    strSF = "0"
                    strDF = "0"
                }
                else if strDiet == "Soy Free"
                {
                    strGF = "0"
                    strSF = "1"
                    strDF = "0"
                }
                else
                {
                    strGF = "0"
                    strSF = "0"
                    strDF = "1"
                }
                cell.btnCheck.isSelected = true
            }
            else
            {
               cell.btnCheck.isSelected = false
            }
            cell.lblTitle.text = arrDietFree[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
           if self.isSelectedIndexSortBy == indexPath.row && self.isIndexSelectedSortBy == true{
                self.isIndexSelectedSortBy = false
            }else{
                self.isIndexSelectedSortBy = true
            }
            self.isSelectedIndexSortBy = indexPath.row
        }
        else
        {
            if self.isSelectedIndexKichen == indexPath.row && self.isIndexSelectedKichen == true{
                 self.isIndexSelectedKichen = false
             }else{
                 self.isIndexSelectedKichen = true
             }
             self.isSelectedIndexKichen = indexPath.row
        }
        self.tblView.reloadData()
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 44
        }
//        else  if indexPath.section == 1
//        {
//
//            return 44
//        }
        else
        {
            return 44
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//
//        let headerView = UIView()
//        headerView.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
//        headerView.backgroundColor = UIColor.white
//
//        let label : UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width, height: 60))
//        label.numberOfLines = 0
//        label.textAlignment = NSTextAlignment.left
//        label.font = UIFont.init(name: "POPPINS-MEDIUM", size: 18)
//        label.textColor = UIColor.black
//        label.text = arrData[section] as? String
//
//        headerView.addSubview(label)
//
//       return headerView
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 60
//    }
}
