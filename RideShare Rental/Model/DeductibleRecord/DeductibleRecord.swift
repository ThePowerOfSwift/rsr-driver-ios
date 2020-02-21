//
//  File.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 01/06/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import Foundation
struct DeductibleRecord: Codable
{
    //String, URL, Bool and Date conform to Codable.
    var id: String
    var payable_amount: String
    var price_per_day: String
    var text: String
 }
