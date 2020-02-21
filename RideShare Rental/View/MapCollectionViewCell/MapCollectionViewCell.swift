//
//  MapCollectionViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    @IBOutlet var mapBtn: CustomButton!

    @IBOutlet var tagimg: UIImageView!
    @IBOutlet var bannerLbl: SwiftyScrollingLabel!
    @IBOutlet var price_permonthLbl: CustomLabel!
    @IBOutlet var price_perweekLbl: CustomLabel!
    @IBOutlet var price_perday: CustomLabel!
    @IBOutlet var user_img: UIImageView!
    @IBOutlet var ratingView: TPFloatRatingView!
    @IBOutlet var car_name: CustomLabel!
    @IBOutlet var car_image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      }
   

}
