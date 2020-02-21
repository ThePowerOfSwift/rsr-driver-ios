//
//  ContracttableVIewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class ContracttableVIewCell: UITableViewCell {
    @IBOutlet var owner_name: CustomLabel!
    
    @IBOutlet var insuranceDocBtn: CustomButton!
    @IBOutlet var spent: CustomLabel!
    @IBOutlet var bookinfo: CustomLabel!
    @IBOutlet var carinfo: CustomLabel!
    @IBOutlet var ratingView: TPFloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
   override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
         // Configure the view for the selected state
    }
    
}
