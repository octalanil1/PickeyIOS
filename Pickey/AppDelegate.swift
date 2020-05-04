//
//  AppDelegate.swift
//  Pickey
//
//  Created by Sunil Pradhan on 15/11/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SystemConfiguration
import AKSideMenu
import Firebase
import FirebaseDynamicLinks
import Stripe
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate, UITabBarDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var TabLogin : UITabBarController! = nil
    var selectTab:NSInteger = 0
    
    var navigationController = UINavigationController()
    let controller = UIViewController()
    var container: AKSideMenu!
    
    var currentLoginUser = UserInfoModal()
    var currentLocation:CLLocation!
    var locationManager = CLLocationManager()
    var addressString : String = ""
    var strCityName : String = ""
    var Latitude = ""
    var Longitude = ""
    var lat = 0.0
    var long = 0.0
    var addressID = ""
    var strHouseNumber: String = ""
    
    var SwitchType = "Chlid"
    //Find Current Date......
    var formattedDate = ""
    let customURLScheme = "https://picky12.page.link"  //https://picky12.page.link/jdF1
    var StrVendortype = "Kitchen"
    var StrDeliverytype = "Delivery"
    
    var deviceToken = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        Thread.sleep(forTimeInterval: 0.3)
        
        
        STPPaymentConfiguration.shared().publishableKey = kStripeKeyTest
        
        GMSServices.provideAPIKey(kGoogleApiKey)
        GMSPlacesClient.provideAPIKey(kGoogleApiKey)
        GMSServices.openSourceLicenseInfo()
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "EEEE-yyyy-MM-dd"
        formattedDate = format.string(from: date)
        
        if UserDefaults.standard.object(forKey: kCurrentUser) != nil &&
            UserDefaults.standard.object(forKey: kLoginCheck) != nil && UserDefaults.standard.object(forKey: kIsRemeber) as! String == "Yes"
        {
            self.currentLoginUser = self.getLoginUser()
            self.showtabbar()
            
            if self.controller.appDelegate.isInternetAvailable() == true{
                self.controller.windowShowActivity(text: "")
                self.performSelector(inBackground: #selector(self.MethodMyCartAPI), with: nil)
            }else
            {
                self.controller.onShowAlertController(title: kNoInternetConnection, message: kInternetError)
            }
        }
        else
        {
            self.showFirstPage()
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(red: 139/255.0, green: 140/255.0, blue: 142/255.0, alpha: 1.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor :UIColor(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)], for: .selected)
        
        /////// Push Notification ///////////////////
        registerForPushNotifications(application: application)
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = self.customURLScheme
        
        //If Tap on DynamicLink
        let activityDic = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary]
        if activityDic != nil {
           //self.switchHomeVC()
        }
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showFirstPage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelComeVC") as! WelComeVC
        navigationController = UINavigationController(rootViewController: welcomeViewController)
        navigationController.isNavigationBarHidden = true
        navigationController.delegate = self
        window?.rootViewController = navigationController
    }
    
    //MARK: Save User
    func saveCurrentUser(currentUserdict: NSDictionary)
    {
        let PickyUser = UserInfoModal.init(dict: currentUserdict)
        let userDefaults = UserDefaults.standard
        let encodeData: Data = NSKeyedArchiver.archivedData(withRootObject: PickyUser)
        userDefaults.set(encodeData, forKey: kCurrentUser)
        userDefaults.synchronize()
    }
    
    //MARK: Get LoggedIn User
    func getLoginUser() -> UserInfoModal
    {
        let userDefault = UserDefaults.standard
        let decode = userDefault.object(forKey: kCurrentUser) as! Data
        let PickyUser : UserInfoModal = NSKeyedUnarchiver.unarchiveObject(with: decode) as! UserInfoModal
        
        return PickyUser
    }
    //MARK:- Userdefault
    func setUserDefaultObj(_ obj:AnyObject, strkey:NSString)
    {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(obj, forKey: strkey as! String)
        userDefault.synchronize()
    }
    func getUserDefaultForKeyBoolValue(_ strkey:NSString) -> Bool?
    {
        let userDefault:UserDefaults = UserDefaults.standard
        return userDefault.object(forKey: strkey as! String) as? Bool
    }
    func getUserDefaultForKey(_ strkey:NSString) -> NSString?
    {
        let userDefault:UserDefaults = UserDefaults.standard
        return userDefault.object(forKey: strkey as! String) as? NSString
    }
    func clearData() 
    {
        let chk = UserDefaults.standard.object(forKey: kIsRemeber) as? String
        
        if chk == "No"
        {
            UserDefaults.standard.removeObject(forKey: kLoginCheck)
            UserDefaults.standard.removeObject(forKey: kCurrentUser)
            UserDefaults.standard.removeObject(forKey: kServerTokenKey)
        }
        self.showFirstPage()
    }
    
    func ShowMainviewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let LeftMenuViewController:SidePanelVC = storyboard.instantiateViewController(withIdentifier: "SidePanelVC") as! SidePanelVC
        LeftMenuViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let home = storyboard.instantiateViewController(withIdentifier: "KitchenListVC") as! KitchenListVC
        
        navigationController = UINavigationController(rootViewController: home)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        container = AKSideMenu(contentViewController: navigationController, leftMenuViewController: LeftMenuViewController, rightMenuViewController: nil)
        container.contentViewShadowEnabled = false
        container.contentViewShadowColor = .black
        container.contentViewShadowOffset = .zero
        container.contentViewShadowOpacity = 0.4
        container.contentViewShadowRadius = 8.0
        container.contentViewFadeOutAlpha = 1.0
        container.contentViewInLandscapeOffsetCenterX = 30.0
        container.contentViewInPortraitOffsetCenterX = 30.0
        container.contentViewScaleValue = 0.7
        
        self.window!.rootViewController = container
    }
    
    //MARK:- TabBar
    
    func showtabbar()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Meals = storyboard.instantiateViewController(withIdentifier: "KitchenListVC") as! KitchenListVC
        let Subscribe = storyboard.instantiateViewController(withIdentifier: "SubscribeVC") as! SubscribeVC
        let Account = storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        
        TabLogin = UITabBarController()
        
        let nav_Meals = UINavigationController(rootViewController: Meals)
        nav_Meals.isNavigationBarHidden = true
        
        let nav_Subscribe = UINavigationController(rootViewController: Subscribe)
        nav_Meals.isNavigationBarHidden = true
        
        let nav_Account = UINavigationController(rootViewController: Account)
        nav_Meals.isNavigationBarHidden = true
        
        let count = [nav_Meals,nav_Subscribe, nav_Account]
        
        TabLogin.viewControllers = count
        TabLogin.delegate = self
        // TabLogin.selectedIndex = 1
        
        let  tabItem1 : UITabBarItem = self.TabLogin.tabBar.items![0]
        tabItem1.image = UIImage (named: "meal")?.scaleTo(CGSize(width: 26, height: 26)).withRenderingMode(.alwaysOriginal)
        tabItem1.selectedImage = UIImage (named: "meal_active")?.scaleTo(CGSize(width: 26, height: 26)).withRenderingMode(.alwaysOriginal)
        // tabItem1.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        tabItem1.title = "Meals"
        
        let  tabItem2 : UITabBarItem = self.TabLogin.tabBar.items![1]
        tabItem2.image = UIImage (named: "subscribe")?.scaleTo(CGSize(width: 26, height: 26)).withRenderingMode(.alwaysOriginal)
        tabItem2.selectedImage = UIImage (named: "subscribe_active")?.scaleTo(CGSize(width: 26, height: 26)).withRenderingMode(.alwaysOriginal)
        // tabItem2.imageInsets = UIEdgeInsets(top:6, left: 0, bottom: -6, right: 0)
        tabItem2.title = "Subscribe"
        
        let  tabItem3 : UITabBarItem = self.TabLogin.tabBar.items![2]
        tabItem3.image = UIImage (named: "account")?.scaleTo(CGSize(width: 26, height: 26)).withRenderingMode(.alwaysOriginal)
        tabItem3.selectedImage = UIImage (named: "account_active")?.scaleTo(CGSize(width: 26, height: 26)).withRenderingMode(.alwaysOriginal)
        //tabItem3.imageInsets = UIEdgeInsets(top:6, left: 0, bottom: -6, right: 0)
        tabItem3.title = "Account"
        
        //  TabLogin.tabBar.backgroundColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
        // TabLogin.tabBar.barTintColor = UIColor(red: 230/255.0, green: 105/255.0, blue: 48/255.0, alpha: 1.0)
        self.window?.makeKeyAndVisible();
        
        let LeftMenuViewController:SidePanelVC = storyboard.instantiateViewController(withIdentifier: "SidePanelVC") as! SidePanelVC
        
        LeftMenuViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        navigationController = UINavigationController(rootViewController: TabLogin)
        navigationController.setNavigationBarHidden(true, animated: false)
        //  container = MFSideMenuContainerViewController .container(withCenter: navigationController, leftMenuViewController: LeftMenuViewController, rightMenuViewController: nil)
        
        container = AKSideMenu(contentViewController: navigationController, leftMenuViewController: LeftMenuViewController, rightMenuViewController: nil)
        container.contentViewShadowEnabled = true
        container.contentViewShadowRadius = 30
        container.contentViewShadowColor = .darkGray
        
        self.window!.rootViewController = container
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        selectTab = TabLogin.selectedIndex
    }
    
    //MARK: Notification Method...............

    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        if (self.currentLoginUser == nil || self.currentLoginUser.userIdString == "" || self.currentLoginUser.userIdString == "nil")
        {
            print("**************didReceiveRemoteNotification***** NOtCall*********")
            return
        }
        UIApplication.shared.applicationIconBadgeNumber -= 1
        let dicUserInfo = userInfo as NSDictionary
        print("dicUserInfo:", dicUserInfo)
        //UpdateCurrentNotification
        if dicUserInfo.object(forKey: "aps") == nil  || !(dicUserInfo.object(forKey: "aps") is NSDictionary) || (dicUserInfo.object(forKey: "aps") as! NSDictionary).count == 0 || (dicUserInfo.object(forKey: "aps") as! NSDictionary).object(forKey: "dictionary") == nil  || !((dicUserInfo.object(forKey: "aps") as! NSDictionary).object(forKey: "dictionary") is NSDictionary) || ((dicUserInfo.object(forKey: "aps") as! NSDictionary).object(forKey: "dictionary") as! NSDictionary).count == 0
        {
            print("Notification not click*************")
            
           if ( application.applicationState == UIApplication.State.inactive || application.applicationState == UIApplication.State.background)
            {
//                let objcNews = NewsDetailVC.init(nibName: "NewsDetailVC", bundle: nil)
//                objcNews.isNavigation = "Noti"
//                objcNews.strNewsID = (dicUserInfo.object(forKey: "aps") as! NSDictionary).valueForNullableKey(key: "news_id")
//
//                if let controller = self.TabLogin.selectedViewController as? UINavigationController
//                {
//                    controller.pushViewController(objcNews, animated: true)
//                }
            }
            else
            {
                let alertView = UIAlertController(title: "Notification alert", message: "", preferredStyle: .alert)
                
                alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        
//                        let objcNews = NewsDetailVC.init(nibName: "NewsDetailVC", bundle: nil)
//                        objcNews.isNavigation = "Noti"
//                        objcNews.strNewsID = (dicUserInfo.object(forKey: "aps") as! NSDictionary).valueForNullableKey(key: "news_id")
//
//                        if let controller = self.TabLogin.selectedViewController as? UINavigationController
//                        {
//                            controller.pushViewController(objcNews, animated: true)
//                        }
                        
                        break
                    case .cancel:
                        break
                    case .destructive:
                        
                        break
                    }
                }))
                alertView.addAction(UIAlertAction(title: "No", style: .cancel) { action in
                    print("Action: DFU resumed")
                })
                window?.rootViewController?.present(alertView, animated: true, completion: nil)
            }
            return
        }
        else
        {
            
        }
    }
    
    //MARK: - My Cart API.................
    @objc func MethodMyCartAPI()
    {
        getallApiResultwithPostTokenMethod(Details:NSMutableDictionary(), strMethodname: kMethodMyCarts) { (responseData, error) in
            
            DispatchQueue.main.async {
                self.controller.hideActivityFromWindow()
                
                if error == nil
                {
                    if (responseData != nil) && (responseData?.object(forKey: kResponseDataStatus) as! Int == kStatusResponseTrue)
                    {
                        
                    }
                    else
                    {
                        
                        self.controller.onShowAlertController(title: kError, message: responseData?.object(forKey: kMessage) as? String)
                    }
                }
                else
                {
                    self.controller.onShowAlertController(title: kError, message: "Having some issue.Please try again.")
                }
            }
        }
    }
    
    //MARK: - Location Manager Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        lat = locValue.latitude
        long = locValue.longitude
        Latitude = String(lat)
        Longitude = String(long)
        currentLocation = manager.location!
        
        let location = CLLocation(latitude: lat, longitude: long) //changed!!!
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
                    self.addressString = self.addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil
                {
                    self.addressString = self.addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil
                {
                    self.addressString = self.addressString + pm.locality! + ", "
                    self.strCityName = pm.locality!
                }
                if pm.subLocality != nil
                {
                    self.strHouseNumber = pm.subLocality!
                }
                if pm.country != nil
                {
                    self.addressString = self.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil
                {
                    self.addressString = self.addressString + pm.postalCode! + " "
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
    
    //MARK:-  Check Internet Connection.............
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK: Other Methods
    func ShowSettingsAlert(message: String)
    {
        let alert = UIAlertController(title: kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        self.window!.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - DynamicLink
   
    // MARK: - DynamicLink
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        if let incomigURL = userActivity.webpageURL{
            let linkHandle = DynamicLinks.dynamicLinks().handleUniversalLink(incomigURL) { (dynamiclink, error) in
                if let dynamiclink = dynamiclink, let _ = dynamiclink.url {
                    self.handleIncomingDynamicLink(dynamicLink: dynamiclink)
                } else {
                    print("dynamiclink = nil")
                }
            }
            return linkHandle
        }
        print("userActivity = nil")
        return false
    }
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    {
        return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Handle deep link.")
        //AppManager.init().showToast("Handle deep link.")
        return true
    }
    
    func handleIncomingDynamicLink(dynamicLink: DynamicLink){
        print("Your dynamic link parameter is = \(String(describing: dynamicLink.url))")
        
        let message = dynamicLink.url?.absoluteString
        
        if message != nil {
            
            
            var queryStringDictionary: [AnyHashable : Any] = [:]
            let urlComponents = message!.components(separatedBy: "&")
            
            for keyValuePair: String? in urlComponents {
                let pairComponents = keyValuePair?.components(separatedBy: "=")
                let key = pairComponents?.first?.removingPercentEncoding
                let value = pairComponents?.last?.removingPercentEncoding
                queryStringDictionary[key] = value
                
                let uniqueArray = key?.components(separatedBy: "?") as! NSArray
                let unique = uniqueArray.object(at: 1) as! String
                let uniqueSprate = unique.components(separatedBy: "=") as NSArray
                
                ////// Insert Value Dict //////////
                let dict = NSMutableDictionary()
                dict.setValue(uniqueSprate.object(at: 0), forKey: "type")
                dict.setValue(value, forKey: "value")
                
//                checkDeep = true
//                let data = UserDataModel.isLoggedIn()
//                if data == nil {
//                    self.switchHomeVC()
//                }
                self.switchToDetails(dict: dict)
                
                break
            }
        }
    }
    
    // MARK: - switchToDetails
    func switchToDetails(dict: NSDictionary) {
        
        let type = dict.object(forKey: "type") as! String
        let value = dict.object(forKey: "value") as! String
        
        if type == "class_uniqueId" {
           // self.showClassDetailsVC(slug: value)
        } else {
           // self.showTeacherDetails(slug: value)
        }
    }
}

// MARK:- Notification Handler
extension AppDelegate {
    
    func registerForPushNotifications(application: UIApplication)
    {
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            })
        }
        else
        {
            //If user is not on iOS 10 use the old methods we've been using
            
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
        }
    }
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        //BackendAPIManager.sharedInstance.backgroundCompletionHandler = completionHandler
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //self.deviceToken =  deviceTokenString
        print("deviceTokenString...................",deviceTokenString)
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.deviceToken = result.token
                UserDefaults.standard.set(self.deviceToken, forKey: kDeviceToken)
                print("kDeviceToken",self.deviceToken)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register:", error)
        
        UserDefaults.standard.set("SIMULATOR", forKey: kDeviceToken)
        UserDefaults.standard.synchronize()
    }
    
    func NotificaionPermissionCheck()
    {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized
                {
                    // Already authorized
                }
                else {
                    // Either denied or notDetermined
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                        (granted, error) in
                        // add your own
                        UNUserNotificationCenter.current().delegate = self
                        let alertController = UIAlertController(title: "Notification Alert", message: "Please enable notifications", preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                })
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(settingsAction)
                        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
        } else {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                print("APNS-YES")
            } else {
                let alertController = UIAlertController(title: "Notification Alert", message: "Please enable notifications", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        } else {
                            UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
