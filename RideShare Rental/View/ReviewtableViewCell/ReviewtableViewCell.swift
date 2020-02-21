//
//  ReviewtableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class ReviewtableViewCell: UITableViewCell {
    @IBOutlet var ratingView: TPFloatRatingView!
    
    @IBOutlet var user_image: UIImageView!
    @IBOutlet var message_Lbl: CustomLabel!
    @IBOutlet var name_Lbl: CustomLabel!
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
