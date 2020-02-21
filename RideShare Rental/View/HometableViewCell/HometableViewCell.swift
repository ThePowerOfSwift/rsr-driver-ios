//
//  HometableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 07/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class HometableViewCell: UITableViewCell {
    @IBOutlet var wrapperView: UIView!

    @IBOutlet var offer_tag: UIImageView!
    @IBOutlet var vehicle_no: CustomLabel!
    @IBOutlet var vin_number: CustomLabel!
    @IBOutlet var priceperday: CustomLabel!
    
    @IBOutlet var pricepermonth: CustomLabel!
    @IBOutlet var priceperweek: CustomLabel!
    @IBOutlet var map_Btn: UIButton!
    @IBOutlet var carimage: UIImageView!
    @IBOutlet var carname: CustomLabel!
    @IBOutlet var ratingView: TPFloatRatingView!
    
    @IBOutlet var bannerLbl: SwiftyScrollingLabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

 wrapperView.layer.masksToBounds = false
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowOpacity = 0.5
        wrapperView.layer.shadowOffset = CGSize(width: -1, height: 1)
        wrapperView.layer.shadowRadius = 1
        
        wrapperView.layer.shadowPath = UIBezierPath(rect: wrapperView.bounds).cgPath
        wrapperView.layer.shouldRasterize = true
        wrapperView.layer.rasterizationScale = UIScreen.main.scale

    }
    func SetRatingView(value:CGFloat)
    {
    ratingView.emptySelectedImage = UIImage(named: "halfstar")
    ratingView.fullSelectedImage = UIImage(named: "fullstar")
    ratingView.contentMode = .scaleAspectFill
    ratingView.maxRating = 5
    ratingView.minRating = 0
    ratingView.rating = value
    ratingView.editable = false
    ratingView.halfRatings = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
