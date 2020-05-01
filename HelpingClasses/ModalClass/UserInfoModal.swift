//
//  UserInfoModal.swift
//  Amax
//
//  Created by Shreya-ios on 18/06/18.
//  Copyright © 2018 Aarti. All rights reserved.
//

import UIKit

class UserInfoModal: NSObject, NSCoding {
    
    var fullNameString          = ""
    var firstNameString          = ""
    var lastNameString          = ""
    var mobileNoString          = ""
    var organizationNameString  = ""
    var emailString             = ""
    var userIdString            = ""
    var countryCodeString       = ""
    var ImageBannerString       = ""
    var profileImageString      = ""
    var strNotiOnOff            = ""
    
    override init() {
        
    }
    
    //MARK:- NSCoding And Decoding Method
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fullNameString, forKey:kFullName)
        aCoder.encode(firstNameString, forKey:kFirstName)
        aCoder.encode(lastNameString, forKey:kLastName)
        aCoder.encode(mobileNoString, forKey: kMobileNumber)
        aCoder.encode(emailString, forKey: kEmail)
        aCoder.encode(userIdString, forKey: kUserId)
        aCoder.encode(countryCodeString, forKey: kCountryCode)
        aCoder.encode(ImageBannerString, forKey: kBannerImage)
        aCoder.encode(profileImageString, forKey: kProfilePicture)
        aCoder.encode(strNotiOnOff, forKey: kMethodNotifyOnOff)
    }
    
    init(dict: NSDictionary) {
        
        if dict.object(forKey: kFullName) != nil && !(dict.object(forKey: kFullName) is NSNull) {
            fullNameString = dict.object(forKey: kFullName) as! String
        }
        if dict.object(forKey: kFirstName) != nil && !(dict.object(forKey: kFirstName) is NSNull) {
            firstNameString = dict.object(forKey: kFirstName) as! String
        }
        if dict.object(forKey: kLastName) != nil && !(dict.object(forKey: kLastName) is NSNull) {
            lastNameString = dict.object(forKey: kLastName) as! String
        }
        if dict.object(forKey: kMobileNumber) != nil && !(dict.object(forKey: kMobileNumber) is NSNull) {
            mobileNoString = dict.valueForNullableKey(key: kMobileNumber)
        }
        if dict.object(forKey: kEmail) != nil && !(dict.object(forKey: kEmail) is NSNull) {
            emailString = dict.object(forKey: kEmail) as! String
        }
        if dict.object(forKey: kUserId) != nil && !(dict.object(forKey: kUserId) is NSNull) {
            userIdString = dict.valueForNullableKey(key: kUserId)
        }
        if dict.object(forKey: kCountryCode) != nil && !(dict.object(forKey: kCountryCode) is NSNull) {
            countryCodeString = dict.valueForNullableKey(key: kCountryCode)
        }
        if dict.object(forKey: kBannerImage) != nil && !(dict.object(forKey: kBannerImage) is NSNull) {
            ImageBannerString = dict.valueForNullableKey(key: kBannerImage)
        }
        if dict.object(forKey: kProfilePicture) != nil && !(dict.object(forKey: kProfilePicture) is NSNull) {
            profileImageString = dict.valueForNullableKey(key: kProfilePicture)
        }
        if dict.object(forKey: kMethodNotifyOnOff) != nil && !(dict.object(forKey: kMethodNotifyOnOff) is NSNull) {
            strNotiOnOff = dict.valueForNullableKey(key: kMethodNotifyOnOff)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fullNameString = aDecoder.decodeObject(forKey: kFullName) as! String
        firstNameString = aDecoder.decodeObject(forKey: kFirstName) as! String
        lastNameString = aDecoder.decodeObject(forKey: kLastName) as! String
        mobileNoString = aDecoder.decodeObject(forKey: kMobileNumber) as! String
        emailString = aDecoder.decodeObject(forKey: kEmail) as! String
        userIdString = aDecoder.decodeObject(forKey: kUserId) as! String
        countryCodeString = aDecoder.decodeObject(forKey: kCountryCode) as! String
        ImageBannerString = aDecoder.decodeObject(forKey: kBannerImage) as! String
        profileImageString = aDecoder.decodeObject(forKey: kProfilePicture) as! String
        strNotiOnOff = aDecoder.decodeObject(forKey: kMethodNotifyOnOff) as! String
    }
}
