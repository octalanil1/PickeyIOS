//
//  GooglePlaceVC.swift
//  Pickey
//
//  Created by octal on 02/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit

class GooglePlaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
     override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle: "", leftbuttonImageName: "", RightbuttonName: "")
            
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(methodMenu(_:)))
            
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
        
        
    @objc func methodMenu(_ sender: UIButton!)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else 
        {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "googleMapCell")
            return cell!

        }
       else
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "GooglePlaceCell") as! GooglePlaceCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell

        }
       
    }
    

}
