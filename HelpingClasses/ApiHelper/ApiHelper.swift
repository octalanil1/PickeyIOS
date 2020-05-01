//  ApiHelper.swift
//  EdgiLife
//
//  Created by New Idea Technology on 7/20/18.
//  Copyright © 2018 Ashish-IOS. All rights reserved.
//

import Foundation
import Alamofire

// Check User
func getAllApiResults(Details: NSDictionary,srtMethod : String, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    let url = ApiURL.Base_URL + srtMethod
    print("******URL*******: ",url)
    print("******Parameters*******: ",Details)
    
    Alamofire.request(url, method: .post, parameters: Details as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
        print("******URL-Result*******: ",url,response)
        DispatchQueue.main.async {
            completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
        }
        #if DEBUG
        //print("signUpResponse Debug Data: \(String(describing: response.result.value))")
        #endif
    }
}

func getallApiResultwithGetMethod(strMethodname : String,Details: NSDictionary, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    let url = ApiURL.Base_URL + strMethodname
    print("getAllApiResults: ",url)
    print("getAllApiResults: ",Details)
    
    Alamofire.request(url, method: .get, parameters: Details as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
        
        DispatchQueue.main.async {
            completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
        }
        #if DEBUG
        //print("signUpResponse Debug Data: \(String(describing: response.result.value))")
        #endif
    }
}

func getallApiResultwithPostTokenMethod(Details: NSDictionary,strMethodname : String, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    var strToken = ""
    if UserDefaults.standard.object(forKey: kServerTokenKey) != nil
    {
        strToken = UserDefaults.standard.object(forKey: kServerTokenKey)! as! String
    }
    print("Token :",strToken)
    
    let headers: HTTPHeaders = [
        // "Content-Type":"application/x-www-form-urlencoded"
        // "Accept": "application/json",
        "token": strToken
    ]
    let url = ApiURL.Base_URL + strMethodname
    print("getAllApiResults: ",url)
    print("getAllApiResults: ",Details)
    
    print(url, Details)
    
    Alamofire.request(url, method: .post, parameters: Details as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
        
        DispatchQueue.main.async {
            completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
            print("response =",response.result.value)
            print("error =",response.result.error)
        }
        #if DEBUG
        //print("signUpResponse Debug Data: \(String(describing: response.result.value))")
        #endif
    }
}

func getallApiResultwithGetTokenMethod(strMethodname : String,Details: NSDictionary, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
   var strToken = ""
    if UserDefaults.standard.object(forKey: kServerTokenKey) != nil
    {
        strToken = UserDefaults.standard.object(forKey: kServerTokenKey)! as! String
    }
    print("Token :",strToken)
    
    let headers: HTTPHeaders = [
        // "Content-Type":"application/x-www-form-urlencoded"
        // "Accept": "application/json",
        "token": strToken
    ]
    let url = ApiURL.Base_URL + strMethodname
    print("getAllApiResults: ",url)
    print("getAllApiResults: ",Details)
    
    print(url, Details)
    
    Alamofire.request(url, method: .get, parameters: Details as? Parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
        print("response = ",response)
        DispatchQueue.main.async {
            completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
        }
        #if DEBUG
        //print("signUpResponse Debug Data: \(String(describing: response.result.value))")
        #endif
    }
}

func getallApiResultwithimagePostMethod(strMethodname : String,userimageData : Data,userbannerData : Data,struserimageKey : String,struserbannerKey : String,Details: NSDictionary, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    var strToken = ""
    if UserDefaults.standard.object(forKey: kServerTokenKey) != nil
    {
        strToken = UserDefaults.standard.object(forKey: kServerTokenKey)! as! String
    }
    print("Token :",strToken)
    
    let headers: HTTPHeaders = [
        // "Content-Type":"application/x-www-form-urlencoded"
        // "Accept": "application/json",
        "token": strToken
    ]
    let url = ApiURL.Base_URL + strMethodname
    print("getAllApiResults: ",url)
    print("getAllApiResults: ",Details)
    
    Alamofire.upload(multipartFormData:
        { multipartFormData in
            
            if userimageData.count > 0
            {
                multipartFormData.append((userimageData), withName: struserimageKey, fileName: "file.png", mimeType: "image/jpeg")
            }
            if userbannerData.count > 0
            {
                multipartFormData.append((userbannerData), withName: struserbannerKey, fileName: "file1.png", mimeType: "image/jpeg")
            }
            
            for (key, val) in Details {
                
                multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            
    },to: url,method:.post,headers:headers, encodingCompletion:
        { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    DispatchQueue.main.async {
                        completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
                        print("response = ", response.result.value)
                    }
                }
            case .failure(let encodingError):
                
                print(encodingError)
            }
    }
    )
}


func getallApiResultwithimagePostTokenMethodMethod(strMethodname : String,imgData : Data,strImgKey : String,Details: NSDictionary, completionHandler : @escaping (NSDictionary?, NSError?) -> ())
{
    var manager = Alamofire.SessionManager.default
    // manager.session.configuration.timeoutIntervalForRequest = 500
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 3000
    configuration.timeoutIntervalForResource = 3000
    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    manager = Alamofire.SessionManager(configuration: configuration)
    //Alamofire.SessionManager(configuration: configuration)
    
    var strToken = ""
    if UserDefaults.standard.object(forKey: kServerTokenKey) != nil
    {
        strToken = UserDefaults.standard.object(forKey: kServerTokenKey)! as! String
    }
    print("Token :",strToken)
    
    let headers: HTTPHeaders = [
        "Authorization":  "Bearer" + strToken
    ]
    
    let url = ApiURL.Base_URL + strMethodname
    print("getAllApiResults: ",url)
    print("getAllApiResults: ",Details)
    
    Alamofire.upload(multipartFormData:
        { multipartFormData in
            
            if imgData.count > 0
            {
                multipartFormData.append((imgData), withName: strImgKey, fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, val) in Details {
                
                multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            
    },to: url,method:.post,headers:headers, encodingCompletion:
        { encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
 
                    DispatchQueue.main.async {
                        completionHandler(response.result.value as! NSDictionary? , response.result.error as NSError?)
                    }
                }
            case .failure(let encodingError):
                
                print(encodingError)
            }
    }
    )
}


