//
//  Constant.swift
//  HPD
//
//  Created by saurabh on 25/03/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
}

//MARK:Location Data

var arrAllDate = [String]()
var arrDates = [String]()
var arrSelectDateList = [String]()
var arrAllWeekDayName = [String]()
var arrDatesInGivenMonthYear = [String]()
var arrSelectedDate = NSMutableArray()
var arrSelectedFullDate = NSMutableArray()
var arrSelectedDay = NSMutableArray()
var dictReplaceParameter = NSMutableDictionary()
var strSelectFormattedString = ""
var strRatingOrder = ""
var strGF = ""
var strSF = ""
var strDF = ""
var isNavigationFrom = ""

var strSelectedDay = ""

var year = Int()
var month = Int()

var StrCurrentaddress : String = ""
var StraddressString : String = ""
var StrCityName : String = ""
var StrLatitude = ""
var StrLongitude = ""
var Strlat = 0.0
var Strlong = 0.0
var StrHouseNumber: String = ""
var StrAddressID: String = ""
var StrAddresstype: String = ""
var StrLandMark: String = ""


var isNavigationAddToCart = ""

struct ApiURL
{
   //static let Base_URL         = "http://192.168.1.104/picky/web_services3/"         // Local
    static let Base_URL         = "http://56.octallabs.com/pickyqc/web_services3/"    // QC
  //  static let Base_URL         = "http://56.octallabs.com/picky/web_services3/"    // live
    static let Image_URL        = "http://192.168.1.213/picky/"
}
struct OrderModel {
    static var counterValue = 1
    static var TotalPriceCalculate = 0
}

// User Name  - tanchevaivanka@gmail.com
// Password - Ashan1578, Augustus09$
 
let kGoogleApiKey           = "AIzaSyDlkhiAzF897zw7k2MYTj6xR_0bi5ZLBM4"

/*
//User Name  - octal.team1@gmail.com
//Password -
let kGoogleApiKey           = "AIzaSyCzn4LOSQom1itWeyGTGcPfHn-aRwYXN18"
//"https://maps.googleapis.com/maps/api/place/autocomplete/json"
 */


// Stripe Test
//sunil.kumar@octalinfosolution.com
//Octal@123

//https://www.appcoda.com/ios-stripe-payment-integration/
//https://dashboard.stripe.com/test/dashboard

let kStripeKeyTest              = "pk_test_ZhfFoy3mVGwlhmV52FbojkWY"  //Sunil "pk_test_Q0Xa7T8Nl24KwnPi60AKLt7C00SeDGrpnt"
let kStripeSceret               =  "sk_test_y93WmKBDDcc1hh1wbI7kyNzq"

//let kStripeKeyLive              = "pk_live_uldLtlS8AQhzPcyn4wQ8Bv0D"
//StripeSceret — sk_live_ulX7uP1Pj6D9MlKrAQirTr3f


let kAppName                = "PICKY"

//MARK:- Server Keys
let kServerTokenKey         = "auth_token"
let kResponseDataStatus     = "status"
let kResponseDataDict       = "data"
let kResponse               = "response"
let kRequestDataDict        = "request_data"
let kCurrentUser            = "currentUser"
let kRestaurent             = "restaurent"
let kLoginCheck             = "isLogin"
let kMessage                = "message"
let kDeActive               = "deactive"
let kUnauthenticated        = "unauthenticated"
let kUserStatus             = "user_status"
let kDeviceToken            = "device_token"
let kAgents                 = "agents"
let kAmenities              = "amenities"
let kFeaturedProperty       = "featured"
let kBanner                 = "banner"
let kMedia                  = "media"
let kBusinessDetail         = "business_detail"
let kBusinessName           = "business_name"
let kLocation               = "location"
let kUrl                    = "url"
let ktitle                  = "title"
let kIsRemeber              = "isRemember"

//Mark:-
let kStatusResponseTrue           = 200
let ktokenExpire                  = 204
let kStatusResponseFalse          = 400
let kStatusResponseChange         = 401
let kUserDeactivate               = 203
let knotVerified                  = 205

//MARK:- Maximum Limit Of UITextFeilds
let kMobileNoLength         = 15
let kEmailLength            = 50
let kOTPVerificationLength  = 1
let kPasswordLength         = 20
let kUsernameLength         = 25

//MARK:- Internet Validtaion Message
let kNoInternetConnection = "No Internet Connection"
let kInternetError = "Please check your internet connetion"
let kLocationAccess = "Location access is not granted. Please change access from settings."

//MARK:- API Keys Methods............
let kMethodResendOtp        = "resend_otp"
let kMethodSignUp           = "signup"
let kMethodLogin            = "login"
let kMethodChangePassword   = "change_password"
let kMethodOTPVerify        = "otp_verify"
let kMethodLogOut           = "logout"
let kMethodEditProfile      = "user_profile_update"
let kMethodGetProfile       = "user_profile"
let kMethodInsertLocation   = "insert_location"
let kMethodGetLocation      = "get_location"
let kMethodUpdateLocation   = "update_location"
let kMethodDeleteLocation   = "delete_location"
let kMethodKitchenList      = "get_nearby_providers"
let kMethodKitchenListNew   = "get_nearby_providers_new"
let kMethodMenuItem         = "kitchen_menu_items"
let kMethodKitchenDetail    = "kitchen_farm_details"
let kMethodDefaultLocation  = "make_default_location"
let kMethodMyReview         = "my_reviews"
let kMethodAddOrder         = "add_order"
let kMethodMyOrders         = "my_orders"
let kMethodOrderSuccess     = "order_success"
let kMethodOrderDetail      = "order_detail"
let kMethodGetPromocode     = "get_promocode"
let kMethodApplyPromocode   = "apply_promocode"
let kMethodNotificationList = "notification_list"
let kMethodWalletHistory    = "wallet_history"
let kMethodAddReview        = "add_review"
let kMethodCmsPages         = "cms_pages"
let kMethodCancelOrder      = "user_order_remove"
let kMethodAddWallet        = "add_wallet"
let kMethodNotifyOnOff      = "push_notification"
let kMethodDatesOnMap       = "dates_on_map"
let kMethodFAQ              = "faq"
let kMethodAddToCart        = "add_to_cart"
let kMethodMyCarts          = "my_carts"
let kMethodDeleteCart       = "delete_cart"
let kMethodChangeMenuToCart     = "change_menu_to_cart"
let kMethodEnableDisableDate    = "enable_disable_data"
let kMethodMySubscriptionPlan   = "my_subscription_plan"
let kMethodKitchenMenuDetail    = "kitchen_menu_details"
let kMethodKitchenMenuByDay     = "kitchen_menus_by_day"
let kReplaceItem            = "item_replacement_request"

//MARK:- API Keys
let kUserId             = "user_id"
let kCountryCode        = "country_code"
let kMobileNumber       = "mobile_number"
let kMobile             = "mobile"
let kName               = "name"
let kFirstName          = "first_name"
let kLastName           = "last_name"
let kFullName           = "full_name"
let kEmail              = "email"
let kDeviceType         = "device_type"
let kType               = "type"
let kDeviceName         = "IOS"
let kDeviceId           = "device_id"
let kId                 = "id"
let kTempId             = "tmp_id"
let kVerifyType         = "verify_type"
let kPassword           = "password"
let kVendorType         = "vendor_type"
let kTimeslotFrom       = "timeslot_from"
let kTimeslotTo         = "timeslot_to"
let kLunchFrom          = "lunch_from"
let kLunchTo            = "lunch_to"
let kDinnerFrom         = "dinner_from"
let kDinnerTo           = "dinner_to"
let kDeliveryNote       = "delivery_note"
let kOtp                = "otp"
let kCurrentPassword    = "current_password"
let kNewPassword        = "new_password"
let kOldPassword        = "old_password"
let kGender             = "gender"
let kBannerImage        = "user_banner"
let kProfilePicture     = "user_image"
let kDob                = "dob"
let kDay                = "day"

// KitchenList Key
let kSearchName         = "search_name"
let kFarmList           = "Farm"
let FarmImage           = "farm_image"
let FarmName            = "farm_name"
let FarmAddress         = "farm_address"
let kKitchenList        = "Kitchen"
let kKitchenMenu        = "kitchenMenu"
let kKitchenCategory    = "kitchen_category"
let kCategoryMenu       = "category_menu"
let kCategoryName       = "category_name"
let kPromocodes         = "promocodes"
let KitchenImage        = "kitchen_image"
let kIcon               = "icon"
let kItemIcon           = "item_icon"
let Kitchenname         = "kitchen_name"
let KitchenEmail        = "email"
let KitchenBreakfast    = "Breakfast"
let KitchenLunch        = "Lunch"
let KitchenDinner       = "Dinner"
let KitchenAddress      = "kitchen_address"
let KitchenDescrition   = "description"
let KitchenCreatedDate  = "created"
let KitchenRating       = "rating"
let kReviews            = "reviews"
let kReview             = "review"
let KTotalPrice         = "total_price"
let KTotal              = "total"
let KitchenDescription  = "kitchen_description"
let kBreakfastTitle     = "breakfast_title"
let kBreakfastDescription  = "breakfast_description"
let kDesc               = "desc"
let kAsc                = "asc"
let kKitchenDetails     = "kitchen_details"
let kDeliveryAddress    = "delivery_address"
let kOrderCreated       = "order_created"
let kKitchenMenus       = "kitchen_menus"
let kDeliveryStatus     = "delivery_status"
let kOrderDateTime      = "order_date_time"
let kCartExist          = "cart_exist"
let kPlanMenus          = "plan_menus"
let kCartId             = "cart_id"
let kCartMenuId         = "cart_menu_id"
let kKitchenCategoryName          = "kitchen_category_name"
let kOrderPlan          = "order_plan"
let kReplace            = "is_replace"
//Meal
//let kItemName           = "food_type_name"
let kItemPrice          = "item_price"
let kPrice              = "price"
let kMenu               = "menu"
let kItem               = "item"
let kMealType           = "meal_type"
let kHumanType          = "human_type"
let kKitchenID          = "kitchen_id"
let kProviderID         = "provider_id"
let kPlans              = "plans"
let kPlan               = "plan"
let kItemDiscountedPrice = "item_discounted_price"
let kKitchenMenuId      = "kitchen_menu_id"
let kKitchenCategoryId  = "kitchen_category_id"
let kCategoryId         = "category_id"
let kDayLeft            = "day_left"
let kQty                = "qty"
let kSubtotal           = "subtotal"
//Production
let kSubMenu            = "sub_menu"
let kItemDescription    = "item_description"
let kItemName           = "item_name"
let kMenuAmount         = "menu_amount"
//Plans
let kDays               = "days"
let kPlanDays           = "plan_days"
let kPlanDay            = "plan_day"
let kPlanPrice          = "plan_price"
let kPlanID             = "id"
let kPlanid             = "plan_id"
//Location
let kDefaultAddress     = "default_address"
let kDefaultAddressID   = "default_address_id"
let kUserAddress        = "user_address"
let kUserAddressID      = "user_address_id"
//LocationApiKey
let kIsDefault          = "is_default"
let kAddress            = "address"
let kAddressId          = "address_id"
let kAddressType        = "address_type"
let kLatitude           = "latitude"
let kLongititude        = "longitude"
let kFlatNumber         = "flat_number"
//Rate and Review
let kAddReview          = "add_review"
let kselectPlanID       = "plan_id"
let kPromoCode          = "promocode"
let kAmount             = "amount"
let kSpcialNote         = "special_note"
let kDates              = "dates"
let kDate               = "date"
let kOrderQuantity      = "order_quantity"
let kisRating           = "is_rating"
let kKitchenReviewData  = "kitchen_review_data"
let kRating             = "rating"
let kQuantity           = "quantity"
let kisSave             = "is_save"
let kCardId             = "card_id"

//Promo Code
let kDiscountValue      = "discount_value"
let kCouponCode         = "coupon_code"
let KBone               = "bone"
let KImmunity           = "immunity"
let KBrain              = "brain"
let KTotalAmount        = "total_amount"
let KItems              = "items"
let KImages             = "images"
let KImage              = "image"
//Wallet
let kWalletAmount       = "wallet_amount"
let kOrderId            = "order_id"
let kReasonCancel       = "reason"
let kUsedAmount         = "used_amount"
let kRefaundAmount      = "refaund_amount"
let kSlug               = "slug"
let kDeliveryTimeFrom   = "delivery_from_time"
let kDeliveryTimeTo     = "delivery_to_time"
let kDeliveryFee        = "delivery_fee"
let kPaymentToken       = "payment_token"
let kisCanceled         = "is_canceled"
let kPage               = "page"
let kUserWalletAmount   = "user_wallet_amount"
let kPromocodeName      = "promocode_name"
let kOrderDelivery      = "order_delivery"
let kOrderDate          = "order_date"
let kOrderStatus        = "order_status"
let kDayCount           = "day_count"
let kMenuName           = "menu_name"
let kAllDate            = "all_date"
let kDisableDates       = "disable_data"
let kEnableDates        = "enable_data"
let kAnswer             = "answer"
let kQuestion           = "question"
let kDateArray          = "date_array"
let kMenu_plans         = "menu_plans"
let kCart               = "cart"
let kOrderAmount        = "order_amount"

let emptyExpiryError                = "Enter your expiry date."
let emptyCardNoError                = "Enter your card number."
let validAccountNoError             = "account number should contain min 8 and max 20 digits."
let emptyCVVError                   = "Enter your CVV."
let validCVVError                   = "CVV should contain atleast 3"

//MARK:- Registration Screen Validation Message
let emptyMobileNoError              = "Enter your mobile number."
let emptyEmailAddressError          = "Enter your email address."
let emptyAddressError               = "Enter your address."
let validMobileNumberError          = "Mobile number should contain min 7 and max 15 digits."
let validEmail                      = "Enter a valid email address."
let emptyMobileNoAndEmailError      = "Enter your email/mobile number."
let emptyDOB                        = "Enter your DOB."
let validMobile                     = "Mobile number should contain min 7 and max 15 digits."
let emptyPasswordError              = "Enter your password."
let validPasswordError              = "Password should contain at least 8 characters."
let emptyFullNameError              = "Enter your name."
let emptyFirstNameError             = "Enter your first name."
let emptyLastNameError              = "Enter your last name."
let validFullNameError              = "Enter a valid name."
let validFirstNameError             = "Enter a valid first name."
let validLastNameError              = "Enter a valid last name."
let emptyCountryCodeError           = "Select your country code."
let ValidBreakFastFromTime          = "Enter the Delivery From time."
let ValidBreakFastToTime             = "Enter the Delivery To time."
let ValidationLarger                = "Delivery From time cannot be greater than Delivery to time."
let emptyMessageError               = "Enter your message."
let emptyAmountError                = "Enter Amount."
let ValidAmountError                = "Enter Valid Amount."
let CartNoComplete                  = "One of your plan in cart is not completed, please complete first."

//MARK:- ResetPassword Screen Validation Message
let emptyResetPasswordError         = "Re-enter your password."
let missMatchPasswordError          = "New Password and Confirm New password does not match."

//MARK:- ChangePassword Screen Validation Message
let emptyCurrentPasswordError       = "Enter your current password."
let validCurrentPasswordError       = "Current password should contain atleast 8 characters."
let emptyNewPasswordError           = "Enter your new password."
let validNewPasswordError           = "New password should contain atleast 8 characters."
let emptyConfirmPassword            = "Enter confirm new password."
let missMatchPasswordsError         = "New password and confirm new password does not match."
 let termsAndCondition              = "Select Our Terms & Condition"
let selectGender                    = "Select Gender"
let selectDOBError                  = "Select Date of Birth"
let emptySMSCodeError               = "Please enter your SMS code."
let kForgotEmail                    = "email_mobile"
let kMethodForgot                   = "forgot_password"
let emptyTextfield                  = "Text cann't be blank."
let kMethodResetPassword            = "reset_password"
let KsearchLocaton                  = "Enter Address"
let KDeliveryAddress                = "Enter Delivery Address"
let emptyDateError                  = "Please select date"
let emptyDeliveryNote               = "Enter Delivery Note"
let kError                          = "Error"
let kUnAuthenticateUser             = "You are not an authenticated user, kindly get registered or Login to use this amazing app."
