//
//  LeaveReviewTableViewCell.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 03/01/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit

class LeaveReviewTableViewCell: UITableViewCell {

    @IBOutlet var address: CustomLabel!
    @IBOutlet var name: CustomLabel!
    @IBOutlet var year_Lbl: CustomLabel!
    @IBOutlet var model_Lbl: CustomLabel!
    @IBOutlet var make_Lbl: CustomLabel!
    @IBOutlet var plate_Lbl: CustomLabel!
    @IBOutlet var veh_Lbl: CustomLabel!
     @IBOutlet var notes: CustomLabel!
    
     @IBOutlet var status_Lbl: CustomLabel!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var showsimcar_Btn: CustomButton!
    @IBOutlet var end_date: CustomLabel!
    @IBOutlet var start_date: CustomLabel!
    @IBOutlet var carname_Lbl: CustomLabel!
    @IBOutlet var car_Image: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
         // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
