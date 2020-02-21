//
//  PastReservationtableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import Shimmer



class PastReservationtableViewCell: UITableViewCell {
    
    @IBOutlet var year_Lbl: CustomLabel!
    @IBOutlet var model_Lbl: CustomLabel!
    @IBOutlet var make_Lbl: CustomLabel!
    @IBOutlet var plate_Lbl: CustomLabel!
    @IBOutlet var veh_Lbl: CustomLabel!
    @IBOutlet var vin_Lbl: CustomLabel!
    @IBOutlet var notes: CustomLabel!

    @IBOutlet var price_Lbl: CustomLabel!
    @IBOutlet var review_Btn: CustomButton!
    @IBOutlet var mytransBtn: CustomButton!
    @IBOutlet var status_Lbl: CustomLabel!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var showsimcar_Btn: CustomButton!
    @IBOutlet var end_date: CustomLabel!
    @IBOutlet var start_date: CustomLabel!
    @IBOutlet var carname_Lbl: CustomLabel!
     @IBOutlet var car_Image: UIImageView!
    @IBOutlet var profpicimg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let shimmeringView = FBShimmeringView(frame: self.status_Lbl.bounds)
        shimmeringView.frame.origin.x = self.status_Lbl.frame.origin.x+5
        shimmeringView.frame.origin.y = self.status_Lbl.frame.origin.y+5
        self.contentView.addSubview(shimmeringView as? UIView ?? UIView())
        shimmeringView.contentView = status_Lbl
        shimmeringView.shimmeringDirection = .left
         shimmeringView.shimmeringBeginFadeDuration = 0.8
        shimmeringView.shimmeringOpacity = 1.0
          shimmeringView.isShimmering = false
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
