//
//  Constant.swift
//  SCIMBO
//
//  Created by CASPERON on 29/12/16.
//  Copyright © 2016 CASPERON. All rights reserved.
//
import Foundation
// let BaseUrl = "http://coreteam.casperon.com/ridesharerental.com/"
//let BaseUrl = "http://rentals.zoplay.com/ridesharerental.com/"
let BaseUrl = "https://www.ridesharerental.com/"
//let BaseUrl = "http://rideshare.casperon.co/"

let googleApiKey = "AIzaSyA81XZRRM6mud8UMUkouzs7IyiH3PwoaYM"

class Constant
 {
    static let sharedinstance=Constant()
    let Register:String = BaseUrl+"app/driver/register"
    let update_location:String = BaseUrl+"app/driver/update_location"
    let login:String = BaseUrl+"app/driver/login"
    let ImgUrl:String = "https://www.ridesharerental.com/"
    let Regular:String = "SofiaProRegular"
    let Bold:String = "SofiaPro-Bold"
    let SemiBold:String = "SofiaPro-SemiBold"
    let Medium:String = "SofiaPro-Medium"
    let Light:String = "SofiaPro-Light"
    let errormessage:String = "Invalid Request"
    let profile:String = BaseUrl+"app/driver/profile"
    let save_profile:String = BaseUrl+"app/driver/save_profile"
    let change_password:String = BaseUrl+"app/driver/change_password"
    let reset_password:String = BaseUrl+"app/driver/reset_password"
    let find_a_car:String = BaseUrl+"app/driver/find_a_car"
    let more_filter:String = BaseUrl+"app/driver/more_filter"
    let cardetail:String = BaseUrl+"app/driver/car"
    let pricing:String = BaseUrl+"app/driver/pricing"
    let save_licence_image:String = BaseUrl+"app/driver/save_licence_image"
    let save_profile_image:String = BaseUrl+"app/driver/save_profile_image"
    let proceed_booking:String = BaseUrl+"app/driver/proceed_booking"
    let proceed_payment:String = BaseUrl+"app/driver/proceed_payment"
    let reservations:String = BaseUrl+"app/driver/reservations"
    let transactions:String = BaseUrl+"app/driver/transactions"
    let similarcarsnotName = Notification.Name("similarcars")
    let extend_pricing:String = BaseUrl+"app/driver/extend_pricing"
    let proceed_extend_booking:String = BaseUrl+"app/driver/proceed_extend_booking"
    let proceed_extend_payment:String = BaseUrl+"app/driver/proceed_extend_payment"
    let extend_details:String = BaseUrl+"app/driver/extend_details"
    let card_details:String = BaseUrl+"app/driver/card_details"
    let add_card_details:String = BaseUrl+"app/driver/add_card_details"
    let contract_history:String = BaseUrl+"app/driver/contract_history"
    let ambassador:String = BaseUrl+"app/driver/ambassador"
    let contact_us:String = BaseUrl+"app/driver/contact_us"
    let send_referral_mail:String = BaseUrl+"app/driver/send_referral_mail"
    let wishlist:String = BaseUrl+"app/driver/wishlist"
    let wishlists:String = BaseUrl+"app/driver/wishlists"
    let review:String = BaseUrl+"app/driver/review"
    let add_review:String = BaseUrl+"app/driver/add_review"
    let payment:String = BaseUrl+"app/driver/payment"
    let extend_payment:String = BaseUrl+"app/driver/extend_payment"
    let sent_otp:String = BaseUrl+"app/driver/sent_otp"
    let logout:String = BaseUrl+"app/driver/logout"
    let sample_tree:String = BaseUrl+"app/driver/ambassador"
    let save_amb_paypal_id:String = BaseUrl+"app/driver/save_amb_paypal_id"
    let tree_change:String = BaseUrl+"app/driver/tree_change"
    let save_driver_claim:String = BaseUrl+"app/driver/save_driver_claim"
    let save_claimant_claim:String = BaseUrl+"app/driver/save_claimant_claim"
    let leave_review:String = BaseUrl+"app/driver/leave_review"
  
    
    
    //ConvOwner
    let inbox:String = BaseUrl+"app/driver/inbox"
    let message:String = BaseUrl+"app/driver/message"
    let send_message:String = BaseUrl+"app/driver/send_message"

    
    //ConvAdmin
    let inbox_admin:String = BaseUrl+"app/driver/inbox_admin"
    let admin_message:String = BaseUrl+"app/driver/admin_message"
    let send_admin_message:String = BaseUrl+"app/driver/send_admin_message"
    
    
    //DirectOwnerOwner
    let inbox_direct:String = BaseUrl+"app/driver/inbox_direct"
    let direct_message:String = BaseUrl+"app/driver/direct_message"
    let send_direct_message:String = BaseUrl+"app/driver/send_direct_message"
    
    //DirectAdmin
    let inbox_direct_admin:String = BaseUrl+"app/driver/inbox_direct_admin"
    let direct_admin_message:String = BaseUrl+"app/driver/direct_admin_message"
    let send_direct_admin_message:String = BaseUrl+"app/driver/send_direct_admin_message"

//NEw Message
    
    let start_new_direct_conversation:String = BaseUrl+"app/driver/start_new_direct_conversation"
    let start_new_direct_admin_conversation:String = BaseUrl+"app/driver/start_new_direct_admin_conversation"
    
   // Signature
    let upload_signature_image:String = BaseUrl+"app/driver/upload_signature_image"
    
    
    //Phone No Verification
    let send_verification_message:String = BaseUrl+"app/driver/send_verification_message"
    let resend_verification_message:String = BaseUrl+"app/driver/resend_verification_message"
     let verify_mobile:String = BaseUrl+"app/driver/verify_mobile"
    
    
    //Delete message
    let delete_messages:String = BaseUrl+"app/driver/delete_messages"
    let delete_admin_messages:String = BaseUrl+"app/driver/delete_admin_messages"
    let delete_direct_messages:String = BaseUrl+"app/driver/delete_direct_messages"
      let resend_email_verification:String = BaseUrl+"app/driver/resend_email_verification"
 
    
//    app/driver/delete_message
//    booking_no
//
 
//    app/driver/delete_admin_message
//    booking_no
    
    
//    booking_nos
//
//    app/driver/delete_direct_message
//    booking_no
    
    
 
}
