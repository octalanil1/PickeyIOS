//
//  AddLocationVC.swift
//  Pickey
//
//  Created by octal on 24/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class AddLocationVC: UIViewController,UITextFieldDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var txt_Search:UITextField!
    @IBOutlet weak var txt_Landmark:UITextField!
    @IBOutlet weak var txtHouseNo: UITextField!
    @IBOutlet weak var lblFullAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var viewHome: UIView!
    @IBOutlet weak var viewWork: UIView!
    @IBOutlet weak var viewOther: UIView!
    @IBOutlet weak var imgWork: UIImageView!
    @IBOutlet weak var imgOther: UIImageView!
    @IBOutlet weak var imgHome: UIImageView!
    
    var isNavigation = ""
    var AddressDataStore = NSDictionary()
    var marker = GMSMarker()
    let locationManager = CLLocationManager()
    var circle = GMSCircle()
    var isNavigationGoogle = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //get current user location for startup
         if CLLocationManager.locationServicesEnabled() {
            self.appDelegate.locationManager.startUpdatingLocation()
         }
        
        addInputAccessoryForTextFields(textFields: [txt_Landmark], dismissable: true, previousNextable: true)
        
        if isNavigation == "AddAddress" || isNavigation == "signup"
        {
            StrAddresstype = "Home"
            StrCityName = ""
            Strlat = 0.0
            Strlong = 0.0
            StraddressString = ""
            StrHouseNumber = ""
            StrLandMark = ""
        }
        
            
        else if isNavigation == "UpdateAddress"
        {
            StrLandMark = AddressDataStore.valueForNullableKey(key: "flat_number")
            StrAddresstype = AddressDataStore.valueForNullableKey(key: "address_type")
            StraddressString = AddressDataStore.valueForNullableKey(key: "address")
            StrLatitude = AddressDataStore.valueForNullableKey(key: "latitude")
            Strlat = Double(StrLatitude) as! Double
            StrLongitude = AddressDataStore.valueForNullableKey(key: "longitude")
            Strlat = Double(StrLatitude) as! Double
            let housenumberarr = StraddressString.components(separatedBy: ",")
            
            if housenumberarr.count == 1
            {
                let houseno = housenumberarr[0]
                StrHouseNumber = houseno
            }
            else
            {
                let houseno = housenumberarr[0] + housenumberarr[1]
                StrHouseNumber = houseno
            }
        }
    }
    @IBAction func btntextsearch()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoogleLocationVC") as! GoogleLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(LocationChange(_:)), name: NSNotification.Name(rawValue: "SendGoogleLocation"), object: nil)
        settext()
    }
    
    @objc func LocationChange(_ notification: Notification)
    {
        isNavigationGoogle = notification.object as! String
        settext()
    }
    
    func settext()
    {
        if isNavigation == "AddAddress" || isNavigation == "signup"
        {
            
            self.MapView.camera = GMSCameraPosition.camera(withLatitude:self.appDelegate.lat, longitude: self.appDelegate.long, zoom: 50)
            let position = CLLocationCoordinate2DMake(self.appDelegate.lat,self.appDelegate.long)
            self.marker = GMSMarker(position: position)
            self.marker.title = self.appDelegate.addressString
            self.marker.icon = UIImage.init(named: "location")
            self.marker.map = self.MapView
            //circle = GMSCircle(position: position, radius: 7)
            //circle.strokeColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            //circle.fillColor = UIColor(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 0.05)
            //circle.map = self.MapView
            MapView.isMyLocationEnabled = true
            MapView.settings.myLocationButton = true
            MapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)
            
            txt_Search.text = self.appDelegate.addressString
            self.lblAddress.text = self.appDelegate.strHouseNumber
            lblFullAddress.text = self.appDelegate.addressString
            txtHouseNo.text = self.appDelegate.strHouseNumber
            
             self.MapView.delegate = self
        }
        
        else
        {
            self.MapView.camera = GMSCameraPosition.camera(withLatitude:Strlat, longitude: Strlong, zoom: 50)
            let position = CLLocationCoordinate2DMake(Strlat,Strlong)
            self.marker = GMSMarker(position: position)
            self.marker.title = StraddressString//self.appDelegate.addressString
            self.marker.icon = UIImage.init(named: "location")
            self.marker.map = self.MapView
            circle = GMSCircle(position: position, radius: 7)
            circle.strokeColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            circle.fillColor = UIColor(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 0.05)
            circle.map = self.MapView
            txt_Search.text = StraddressString
            txt_Landmark.text = StrLandMark
            self.lblAddress.text = StrHouseNumber
            lblFullAddress.text = StraddressString
            txtHouseNo.text = StrHouseNumber
        }
        
        if isNavigationGoogle == "GoogleLocation"
        {
                self.MapView.camera = GMSCameraPosition.camera(withLatitude:Strlat, longitude: Strlong, zoom: 50)
                           let position = CLLocationCoordinate2DMake(Strlat,Strlong)
                           self.marker = GMSMarker(position: position)
                           self.marker.title = StraddressString//self.appDelegate.addressString
                           self.marker.icon = UIImage.init(named: "location")
                           self.marker.map = self.MapView
                           circle = GMSCircle(position: position, radius: 7)
                           circle.strokeColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
                           circle.fillColor = UIColor(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 0.05)
                           circle.map = self.MapView
                           txt_Search.text = StraddressString
                            txt_Landmark.text = StrLandMark
                           self.lblAddress.text = StrHouseNumber
                           lblFullAddress.text = StraddressString
                           txtHouseNo.text = StrHouseNumber
        }
        if StrAddresstype == "Other"
        {
            viewHome.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
            viewWork.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
            viewOther.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
            
            lblHome.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
            lblWork.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
            lblOther.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            
            imgHome.image = UIImage.init(named: "homeunselect")
            imgWork.image = UIImage.init(named: "workunselect")
            imgOther.image = UIImage.init(named: "locationselect")
        }
        else if StrAddresstype == "Work"
        {
            viewHome.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
            viewOther.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
            viewWork.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
            
            lblHome.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
            lblOther.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
            lblWork.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            
            imgHome.image = UIImage.init(named: "homeunselect")
            imgWork.image = UIImage.init(named: "workselect")
            imgOther.image = UIImage.init(named: "locationunselect")
        }
        else{//home
            viewWork.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
            viewOther.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
            viewHome.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
            
            lblWork.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
            lblOther.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
            lblHome.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
            
            imgHome.image = UIImage.init(named: "homeselect")
            imgWork.image = UIImage.init(named: "workunselect")
            imgOther.image = UIImage.init(named: "locationunselect")
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChange(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoogleLocationVC") as! GoogleLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHome(_ sender: UIButton)
    {
        viewWork.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        viewOther.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        viewHome.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
        lblWork.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
        lblOther.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
        lblHome.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
        imgHome.image = UIImage.init(named: "homeselect")
        imgWork.image = UIImage.init(named: "workunselect")
        imgOther.image = UIImage.init(named: "locationunselect")
        StrAddresstype = "Home"
    }
    
    @IBAction func btnWork(_ sender: UIButton)
    {
        viewHome.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        viewOther.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        viewWork.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
        lblHome.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
        lblOther.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
        lblWork.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
        imgHome.image = UIImage.init(named: "homeunselect")
        imgWork.image = UIImage.init(named: "workselect")
        imgOther.image = UIImage.init(named: "locationunselect")
        StrAddresstype = "Work"
    }
    
    @IBAction func btnOther(_ sender: UIButton)
    {
        viewHome.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        viewWork.layer.borderColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        viewOther.layer.borderColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0).cgColor
        lblHome.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
        lblWork.textColor = UIColor.init(red: 156/255.0, green: 157/255.0, blue: 159/255.0, alpha: 1.0)
        lblOther.textColor = UIColor.init(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
        imgHome.image = UIImage.init(named: "homeunselect")
        imgWork.image = UIImage.init(named: "workunselect")
        imgOther.image = UIImage.init(named: "locationselect")
        StrAddresstype = "Other"
    }
    
    @IBAction func btnSaveAndContinue(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.checkValidation()
        {
            if self.appDelegate.isInternetAvailable() == true
            {
                self.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.MethodInsertUpdateLocationApi), with: nil)
                
            } else
            {
                self.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
    }
    
    //MARK:- UITextField Delegates.........
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- UItextFeild Validation Method...........
    func checkValidation() -> Bool
    {
        if self.txtHouseNo.text == ""
        {
            onShowAlertController(title: kError, message: KsearchLocaton)
            return false
        }
        
        return true
    }
    func LocationParameter() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        
        if isNavigation == "signup"
        {
            if isNavigation == "SendGoogleLocation"
            {
                dict.setObject(StraddressString, forKey: kAddress as NSCopying)
                dict.setObject(Strlat, forKey: kLatitude as NSCopying)
                dict.setObject(Strlong, forKey: kLongititude as NSCopying)
                dict.setObject(StrAddresstype, forKey: kAddressType as NSCopying)
                //dict.setObject("No", forKey: kIsDefault as NSCopying)
                dict.setObject(txt_Landmark.text!, forKey: kFlatNumber as NSCopying)
            }
            else{
                dict.setObject(self.appDelegate.addressString, forKey: kAddress as NSCopying)
                dict.setObject(self.appDelegate.Latitude, forKey: kLatitude as NSCopying)
                dict.setObject(self.appDelegate.Longitude, forKey: kLongititude as NSCopying)
                dict.setObject(StrAddresstype, forKey: kAddressType as NSCopying)
                // dict.setObject("No", forKey: kIsDefault as NSCopying)
                dict.setObject(txt_Landmark.text!, forKey: kFlatNumber as NSCopying)
            }
            return dict
        }
        else if isNavigation == "AddAddress"
        {
            dict.setObject(StraddressString, forKey: kAddress as NSCopying)
            dict.setObject(Strlat, forKey: kLatitude as NSCopying)
            dict.setObject(Strlong, forKey: kLongititude as NSCopying)
            dict.setObject(StrAddresstype, forKey: kAddressType as NSCopying)
            //dict.setObject("No", forKey: kIsDefault as NSCopying)
            dict.setObject(txt_Landmark.text!, forKey: kFlatNumber as NSCopying)
            return dict
        }
        else if isNavigation == "UpdateAddress"
        {
            let addressid = String(format: "%@", arguments:[AddressDataStore.object(forKey: "id") as! CVarArg])
            dict.setObject(StraddressString, forKey: kAddress as NSCopying)
            dict.setObject(Strlat, forKey: kLatitude as NSCopying)
            dict.setObject(Strlong, forKey: kLongititude as NSCopying)
            dict.setObject(addressid, forKey: kAddressId as NSCopying)
            dict.setObject(StrAddresstype, forKey: kAddressType as NSCopying)
            dict.setObject(txt_Landmark.text!, forKey: kFlatNumber as NSCopying)
            return dict
        }
        else //editprofile
        {
            dict.setObject(StraddressString, forKey: kAddress as NSCopying)
            dict.setObject(Strlat, forKey: kLatitude as NSCopying)
            dict.setObject(Strlong, forKey: kLongititude as NSCopying)
            dict.setObject(StrAddressID, forKey: kAddressId as NSCopying)
            dict.setObject(StrAddresstype, forKey: kAddressType as NSCopying)
            dict.setObject(txt_Landmark.text!, forKey: kFlatNumber as NSCopying)
            return dict
        }
    }
    @objc func MethodInsertUpdateLocationApi()
    {
        if isNavigation == "signup"
        {
            getallApiResultwithPostTokenMethod(Details: self.LocationParameter(), strMethodname: kMethodInsertLocation) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            self.appDelegate.showtabbar()
                            StrCurrentaddress = (responseData?.object(forKey: kResponseDataDict) as! NSDictionary).valueForNullableKey(key: kAddress)
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
        else if isNavigation == "AddAddress"
        {
            getallApiResultwithPostTokenMethod(Details: self.LocationParameter(), strMethodname: kMethodInsertLocation) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            self.navigationController?.popViewController(animated: true)
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
        else if isNavigation == "UpdateAddress"
        {
            getallApiResultwithPostTokenMethod(Details: self.LocationParameter(), strMethodname: kMethodUpdateLocation) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            self.navigationController?.popViewController(animated: true)
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
        else//editprofile
        {
            getallApiResultwithPostTokenMethod(Details: self.LocationParameter(), strMethodname: kMethodUpdateLocation) { (responseData, error) in
                
                DispatchQueue.main.async {
                    self.hideActivityFromWindow()
                    
                    if error == nil
                    {
                        if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                        {
                            self.navigationController?.popViewController(animated: true)
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
}



// MARK: - CLLocationManagerDelegate
extension AddLocationVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.appDelegate.lat = locValue.latitude
        self.appDelegate.long = locValue.longitude
        self.appDelegate.Latitude = String(self.appDelegate.lat)
        self.appDelegate.Longitude = String(self.appDelegate.lat)
        self.appDelegate.currentLocation = manager.location!
        
        let location = CLLocation(latitude: self.appDelegate.lat, longitude: self.appDelegate.lat) //changed!!!
       // print(location)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if (placemarks?.count)! > 0
            {
                let pm = placemarks![0]
                if pm.subLocality != nil
                {
                    self.appDelegate.addressString = self.appDelegate.addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil
                {
                    self.appDelegate.addressString = self.appDelegate.addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil
                {
                    self.appDelegate.addressString = self.appDelegate.addressString + pm.locality! + ", "
                    self.appDelegate.strCityName = pm.locality!
                }
                if pm.subLocality != nil
                {
                    self.appDelegate.strHouseNumber = pm.subLocality!
                }
                if pm.country != nil
                {
                    self.appDelegate.addressString = self.appDelegate.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil
                {
                    self.appDelegate.addressString = self.appDelegate.addressString + pm.postalCode! + " "
                }
               // print(self.addressString)
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
            print(locValue)
        })
    }

}
