//
//  Extension+Controller.swift
//  Rombot
//
//  Created by New Idea Technology on 1/15/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

typealias addressCompletion = (_: String) -> Void

private var AssociatedObjectHandle: UInt8 = 0
var context = CIContext(options: nil)

// MARK: - Used to scale UIImages use for exact size of image (line no. 42)
extension UIImage
{
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIViewController {
     
    var appDelegate : AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func MethodLoadNavigationBarWithLeftAndRightButtonButton(strTitle : String, leftbuttonImageName : String , RightbuttonName : String)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.red
        self.navigationItem.title = strTitle
        self.navigationController?.navigationItem.backBarButtonItem?.image = UIImage(named: "menu.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let att = [NSAttributedString.Key.font: UIFont(name: "POPPINS-MEDIUM", size: 18)! , NSAttributedString.Key.foregroundColor: UIColor.init(red: 230/255, green: 105/255, blue: 48/255, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = att
        
    }
    
    func methodNavigationBar(strTitle:String)
    {
        let label = UILabel(frame: CGRect(x: 5, y: -05, width: 10, height: 10))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = label.font.withSize(10)
        label.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        label.text = strTitle
        
        // button
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 19, height: 17))
        rightButton.setBackgroundImage(UIImage(named: "filters")!.withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.addTarget(self, action: #selector(methodCart(_:)), for: .touchUpInside)
        rightButton.addSubview(label)
        let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtomItem
    }
    func showDoubleButtonAlert(title:String, message:String, action1:String, action2:String, completion1:@escaping ()->(), completion2:@escaping ()->()) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let act1 = UIAlertAction(title: action1, style: .default) { (action) in
        completion1()
    }
    let act2 = UIAlertAction(title: action2, style: .default) { (action) in
        completion2()
    }
    alert.addAction(act1)
    alert.addAction(act2)
    if let popoverController = alert.popoverPresentationController {
        popoverController.sourceView = self.view
        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popoverController.permittedArrowDirections = []
    }
    
    present(alert, animated: true, completion: nil)
    }
    @objc func methodCart(_ sender : UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddToCartVC") as! AddToCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func methodBack(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func blurEffect(Image: UIImageView) {
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: Image.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(5, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        Image.image = processedImage
    }
    
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false)
    {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "Previous"), style: .plain, target: nil, action: nil)
                previousButton.width = 50
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "Next"), style: .plain, target: nil, action: nil)
                nextButton.width = 50
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    func addInputAccessoryForTextView(textViews: [UITextView], dismissable: Bool = true, previousNextable: Bool = false)
    {
        for (index, textView) in textViews.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "Previous"), style: .plain, target: nil, action: nil)
                previousButton.width = 50
                if textView == textViews.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textViews[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "Next"), style: .plain, target: nil, action: nil)
                nextButton.width = 50
                if textView == textViews.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textViews[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            toolbar.setItems(items, animated: false)
            textView.inputAccessoryView = toolbar
        }
    }
    
    // show alert controller
    func onShowAlertController(title : String?,message : String?,strbtntitle:String?)
    {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: strbtntitle, style: .cancel, handler: nil)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isPasswordValid(testStr:String) -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func showActivity(text : String)
    {
        let viewTemp = activityView()
        viewTemp.frame = (appDelegate.window?.bounds)!
        viewTemp.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        viewTemp.showHudFor(view: viewTemp, withText: text)
        self.view.addSubview(viewTemp)
    }
    
    func hideActivity()
    {
        for view in self.view.subviews
        {
            if view is activityView
            {
                view.removeFromSuperview()
            }
        }
    }
    
    func windowShowActivity(text : String)
    {
        let viewTemp = activityView()
        viewTemp.frame = (appDelegate.window?.bounds)!
        viewTemp.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        viewTemp.showHudFor(view: viewTemp, withText: text)
        appDelegate.window?.addSubview(viewTemp)
    }
    
    func hideActivityFromWindow(){
        if let window = self.appDelegate.window {
            for view in window.subviews {
                if view is activityView {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    
    func onShowAlertController(title : String?,message : String?)
    {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func checkCameraPermission(completionHandler:@escaping (Bool) -> ())
    {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            completionHandler(true)
            // Already Authorized
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    completionHandler(true)
                    // User granted
                } else {
                    //                    self.TabLogin.selectedIndex = self.selectTab
                    completionHandler(false)
                    let alert:UIAlertController=UIAlertController(title: "Permissions", message: "Camera permission is not granted. Go to settings and allow app to access your Camera.", preferredStyle: UIAlertController.Style.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alert.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    {
                        UIAlertAction in
                        
                    }
                    // Add the actions
                    alert.addAction(cancelAction)
                    self.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    // User Rejected
                }
            })
        }
    }
    
    func checkGalleryPermission(completionHandler:@escaping (Bool) -> ())
    {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        // check the status for PHAuthorizationStatusAuthorized or ALAuthorizationStatusDenied e.g
        if status == PHAuthorizationStatus.notDetermined
        {
            PHPhotoLibrary.requestAuthorization({ (statusinner) in
                if statusinner != PHAuthorizationStatus.authorized {
                    //show alert for asking the user to give permission
                    completionHandler(false)
                    let alert:UIAlertController=UIAlertController(title: "Permissions", message: "Gallery permission is not granted. Go to settings and allow app to access your gallery.", preferredStyle: UIAlertController.Style.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alert.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    {
                        UIAlertAction in
                    }
                    // Add the actions
                    alert.addAction(cancelAction)
                    self.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else
                {
                    completionHandler(true)
                }
            })
        }
        else if status != PHAuthorizationStatus.authorized {
            //show alert for asking the user to give permission
            completionHandler(false)
            let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have gallery access permissions. Please go to settings and allow for gallery access permissions.", preferredStyle: UIAlertController.Style.alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            alert.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            {
                UIAlertAction in
            }
            // Add the actions
            alert.addAction(cancelAction)
            self.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        else
        {
            completionHandler(true)
        }
    }
    
    func jsonString(Object: Any) -> String?
    {
        if let objectData = try? JSONSerialization.data(withJSONObject: Object, options: JSONSerialization.WritingOptions(rawValue: 0))
        {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        
        return nil
    }
    
    func jsonValue(from: String) -> [String: Any]? {
        if let data = from.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK:- User Defined Methods................
    func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy MM dd"
        let dateString1 = dateFormatter1.string(from: date)
        arrDates.append(dateString1)
        let StrAllWeekDay = dateString1.convertDatetring_TopreferredFormat(currentFormat: "yyyy MM dd", toFormat: "EEE")
        let StrAllDates = dateString1.convertDatetring_TopreferredFormat(currentFormat: "yyyy MM dd", toFormat: "dd")
        arrAllWeekDayName.append(StrAllWeekDay)
        arrAllDate.append(StrAllDates)
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: 1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
            
            let StrAllWeekDay = dateString.convertDatetring_TopreferredFormat(currentFormat: "yyyy MM dd", toFormat: "EEE")
            let StrAllDates = dateString.convertDatetring_TopreferredFormat(currentFormat: "yyyy MM dd", toFormat: "dd")
            arrAllWeekDayName.append(StrAllWeekDay)
            arrAllDate.append(StrAllDates)
            
            let SelectedDateId = arrAllDate.first
            let SelectedDay = arrAllWeekDayName.first
  //          let DateId = arrDates.first
             
           // if arrSelectedDate.count == 0
           // {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy MM dd"
//                let showDate = dateFormatter.date(from:DateId!)
//                let resultString = dateFormatter.string(from: showDate!)
//                let resultString1 = resultString.convertDatetring_TopreferredFormat(currentFormat: "yyyy MM dd", toFormat: "YYYY-MM-dd")
//                arrSelectDateList.append(resultString1)
                
                arrSelectedDate.add(SelectedDateId)
                arrSelectedDay.add(SelectedDay)
                
                if SelectedDay == "Mon"{
                    strSelectedDay = "1"
                }else if SelectedDay == "Tue"{
                    strSelectedDay = "2"
                }else if SelectedDay == "Wed"{
                    strSelectedDay = "3"
                }else if SelectedDay == "Thu"{
                    strSelectedDay = "4"
                }else if SelectedDay == "Fri"{
                    strSelectedDay = "5"
                }else if SelectedDay == "Sat"{
                    strSelectedDay = "6"
                }else if SelectedDay == "Sun"{
                    strSelectedDay = "7"
                }
                
 //               print(strSelectedDay)
  //          }
        }
        return arrDates
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension UITextField {
    func toStyledTextField() { // Give Round Border and Left Placholder Padding
        // self.layer.masksToBounds = true
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 229/255, green: 230/255, blue: 231/255, alpha: 1.0).cgColor
        // self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        // self.leftViewMode = UITextField.ViewMode.always
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class activityView: UIView
{
    func showHudFor(view:UIView, withText strText:String)
    {
        
        let viewContainer : UIView = UIView.init(frame: CGRect.init(x: 30, y: (ScreenSize.SCREEN_HEIGHT/2) - 100, width: (ScreenSize.SCREEN_WIDTH) - 60, height: 200))
        let rectFrame : CGRect = CGRect.init(x: (viewContainer.frame.size.width/2)-30, y: (viewContainer.frame.size.height/2)-58, width: 60, height: 60)
        let objAJProgressView = AJProgressView()
        
        // Pass the colour for the layer of progressView
        objAJProgressView.firstColor = UIColor.white
        
        // If you  want to have layer of animated colours you can also add second and third colour
        objAJProgressView.secondColor = UIColor.white
        objAJProgressView.thirdColor = UIColor.white
        
        // Set duration to control the speed of progressView
        objAJProgressView.duration = 3.0
        
        // Set width of layer of progressView
        objAJProgressView.lineWidth = 4.0
        
        //Set backgroundColor of progressView
        objAJProgressView.bgColor =  UIColor.black.withAlphaComponent(0.2)
        
        objAJProgressView.show()
        viewContainer.backgroundColor = UIColor.white
        self.addSubview(objAJProgressView)
    }
}


extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        default:
            return .unknown
        }
    }
    
}
