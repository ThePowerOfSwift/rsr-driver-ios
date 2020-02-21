//
//  CarRecord.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 04/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class CarRecord: NSObject  
{
    var car_images:NSArray = NSArray()
    var car_singleimage:String = ""
    var user_image:String = ""
    var car_make:String = ""
    var car_model:String = ""
    var city:String = ""
    var id:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var rent_daily:String = ""
    var rent_monthly:String = ""
    var rent_weekly:String = ""

    var tag:String = ""
    var usage:String = ""
    var v_no:String = ""
    var year:String = ""
    var vin_no:String = ""
    var daily_mileage:String = ""
    var features:NSArray = NSArray()
    var firstname:String = ""
    var ins:String = ""
    var lastname:String = ""
    var lift_uber:String = ""
    var ownerId:String = ""
    var plat_no:String = ""
    var rating:String  = ""
    var rc:String = ""
    var reviews:NSArray = NSArray()
    var status:String = ""
    var verification:String  = ""
    var last_approval:String  = ""
    var response_percent:String  = ""
    var total_cars:String  = ""
    var total_rentals:String  = ""
    var desc:String  = ""
    var ownername:String  = ""
    var notes:String  = ""
    var shareUrl:String  = ""
    var minstay:String = ""
    var unlimited_mileage:String = ""
    var monthly_offer:String = ""
    var weekly_offer:String = ""


    
    var deductibleArr:[DeductibleRecord]!
 
   }
